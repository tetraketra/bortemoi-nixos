{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.my.adguardhome;
in
{
  options.my.adguardhome.reservedDeviceIp = lib.mkOption {
    type = lib.types.str;
    description = "Reserved IP of this device.";
  };

  options.my.adguardhome.localRewrites = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          domain = lib.mkOption {
            type = lib.types.str;
          };
          port = lib.mkOption {
            type = lib.types.port;
          };
        };
      }
    );
  };

  config = {
    networking.nameservers = [ "127.0.0.1" ]; # Must also be DNS provider on router.
    networking.resolvconf.useLocalResolver = true;
    networking.firewall.allowedTCPPorts = [
      53 # DNS
      80 # Caddy HTTP to HTTPS
      443 # Caddy HTTPS
    ];
    networking.firewall.allowedUDPPorts = [
      53 # DNS
      443 # Caddy HTTPS
    ];

    services.adguardhome = {
      enable = true;
      host = "127.0.0.1";
      port = 3001; # Get there via Caddy or similar.
      settings = {
        dns = {
          bind_hosts = [
            "127.0.0.1"
            cfg.reservedDeviceIp
          ];
          upstream_dns = [
            "1.1.1.1"
            "8.8.8.8"
            "9.9.9.9"
          ];
        };

        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          rewrites_enabled = true;
          rewrites = builtins.map (item: {
            domain = item.domain;
            answer = cfg.reservedDeviceIp;
            enabled = true;
          }) cfg.localRewrites;
        };

        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
              "https://raw.githubusercontent.com/Ealenn/AdGuard-Home-List/gh-pages/AdGuard-Home-List.Block.txt"
            ];
      };
    };

    sops.secrets."caddy/cloudflare/api_token".owner = "caddy";
    sops.templates."caddy-env" = {
      owner = "caddy";
      content = ''
        CLOUDFLARE_API_TOKEN=${config.sops.placeholder."caddy/cloudflare/api_token"}
      '';
    };
    systemd.services.caddy.serviceConfig.EnvironmentFile = [
      config.sops.templates."caddy-env".path
    ];
    services.caddy = {
      enable = true;
      virtualHosts = lib.listToAttrs (
        builtins.map (item: {
          name = item.domain;
          value = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:${toString item.port}
              tls {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                resolvers 1.1.1.1 8.8.8.8
              } 
            '';
          };
        }) cfg.localRewrites
      );
    };
  };
}
