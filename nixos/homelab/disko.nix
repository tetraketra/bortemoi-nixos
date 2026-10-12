{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.002538b721a05948";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              size = "4G";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };

            zfs = {
              size = "100%";

              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      hdd1 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c50066b3257f";

        content = {
          type = "gpt";

          partitions = {
            zfs = {
              size = "100%";

              content = {
                type = "zfs";
                pool = "epool";
              };
            };
          };
        };
      };

      hdd2 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c50065395210";

        content = {
          type = "gpt";

          partitions = {
            zfs = {
              size = "100%";

              content = {
                type = "zfs";
                pool = "epool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        mode = "";

        options.ashift = "12";

        rootFsOptions = {
          mountpoint = "none";
          compression = "lz4";
        };

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
        };
      };

      epool = {
        type = "zpool";
        mode = "mirror";

        options.ashift = "12";

        rootFsOptions = {
          mountpoint = "none";
          compression = "lz4";
        };

        datasets = {
          grafana = {
            type = "zfs_fs";
            mountpoint = "/mnt/grafana";
          };
          immich = {
            type = "zfs_fs";
            mountpoint = "/mnt/immich";
          };
          navidrome = {
            type = "zfs_fs";
            mountpoint = "/mnt/navidrome";
          };
          forgejo = {
            type = "zfs_fs";
            mountpoint = "/mnt/forgejo";
          };
        };
      };
    };
  };

  users.groups.grafana.members = [ "bortemoi" ];
  users.groups.immich.members = [ "bortemoi" ];
  users.groups.navidrome.members = [ "bortemoi" ];
  users.groups.forgejo.members = [ "bortemoi" ];

  systemd.tmpfiles.rules = lib.mkAfter [
    "d /mnt/grafana 0775 bortemoi users -0"
    "d /mnt/immich 0775 bortemoi users -0"
    "d /mnt/navidrome 0775 bortemoi users -0"
    "d /mnt/forgejo 0775 bortemoi users -0"
  ];
}
