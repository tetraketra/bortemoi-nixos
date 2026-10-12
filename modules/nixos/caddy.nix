{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.my.caddy;
  makeSetup = pkgs.lib.my.helpers.makeSetup;
in
{
  options.my.caddy.enable = lib.mkEnableOption "My custom Caddy reverse proxy.";
  options.my.caddy.zfs = lib.mkEnableOption "Whether to integrate with ZFS.";

  config = lib.mkIf cfg.enable {
    systemd.services.caddy = {
      after = lib.optionals cfg.zfs [ "zfs-mount.service" ];
      requires = lib.optionals cfg.zfs [ "zfs-mount.service" ];
    };
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddyserver/cache-handler@v0.17.0"
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        hash = "sha256-BjH8Ocyd7fHGVeSYs/nzngAp92vXJDyiynXUFguaJNI=";
      };
      globalConfig = ''
        order cache before rewrite
        cache {
          badger {
            path /var/lib/caddy/cache/badger
          }
          ttl 5m
        }

        log sysd {
          output stdout
          level INFO
          format json
          format filter {
            wrap json
            fields {
              request>headers>X-Api-Key delete
              request>headers>X-Auth-Token delete
              request>uri query {
                delete access_token
                replace password "[REDACTED]"
              }
              request>remote_ip ip_mask 
            }
          }
        }
      '';
    };
  };
}
