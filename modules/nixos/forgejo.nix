{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.bortemoi.com";
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = 3000;
      };
      service.DISABLE_REGISTRATION = true; # Will need to provision bortemoi.
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  #  services.forgejo-runner = {
  #    package = pkgs.forgejo-runner;
  #    instances.default = {
  #      enable = true;
  #      settings.runner.labels = [
  #        "ubuntu-latest:docker://node:16-bullseye"
  #        "ubuntu-22.04:docker://node:16-bullseye"
  #        "ubuntu-20.04:docker://node:16-bullseye"
  #        "ubuntu-18.04:docker://node:16-buster"
  #      ];
  #      secrets.server.connections."forgejo".token_url = "/var/lib/forgejo/forgejoToken.key"; # Path to forgejo runner key file provided by forgejo.
  #      settings.server.connections.forgejo = {
  #        url = "https://localhost:3000";
  #        uuid = "aaaaaaaa-bbbbbbbbbb-cccccccccc-ddddddd"; # UUID of forgejo runner instance
  #      };
  #    };
  #  };#

  sops.secrets."forgejo/admin-password".owner = "forgejo";
  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets."forgejo/admin-password";
      user = "admin";
    in
    ''
      ${adminCmd} create --admin --email "admin@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
}
