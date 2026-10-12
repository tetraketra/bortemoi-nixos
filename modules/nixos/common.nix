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
      # podman-compose # Fresh-build failures. # TODO: Come back to this.
      # podman-tui # Fresh-build failures. # TODO: Come back to this.
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
