{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      # Containers.
      podman-compose
      podman-tui
      dive
    ];

    # Containers.
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
