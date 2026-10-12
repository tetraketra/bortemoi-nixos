{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.common
    inputs.self.nixosModules.fonts
    inputs.self.nixosModules.forgejo
    inputs.self.nixosModules.adguardhome
    inputs.self.nixosModules.caddy
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ./disko.nix
  ];

  my.adguardhome.reservedDeviceIp = "10.0.0.241";
  my.adguardhome.localRewrites = [
    {
      domain = "adguardhome.local.bortemoi.com";
      port = 3001;
    }
  ];

  my.caddy.enable = true;
  my.caddy.zfs = true;

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = true;
  };

  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostName = "homelab";
  networking.hostId = "6b6c9563";

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/bortemoi/.config/sops/age/keys.txt";

  systemd.tmpfiles.rules = lib.mkAfter [ "d /mnt/extra 0775 bortemoi users -" ];
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqJD0ytcvuTkmHuPcLQK6XfBThIL58XcilCjDUif0iC borte@bortemoi.com" # Workstation
    ];

    bortemoi = {
      isNormalUser = true;
      description = "bortemoi";
      initialPassword = "bortemoi";
      extraGroups = [
        "networkmanager"
        "wheel"
        "seat"
        "video"
        "input"
        "render"
      ];
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "bortemoi" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "bortemoi";
      };
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "bortemoi";
      };
    };
  };

  hardware.graphics.enable = true;
  systemd.services.seatd.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };

  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192;
    virtualisation.cores = 8;
  };

  system.stateVersion = "25.11";
}
