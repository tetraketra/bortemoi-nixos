Run VM
```sh
nix run .#nixosConfigurations.homelab.config.system.build.vm
```

Investigate home-manager errors on the VM
```sh
systemctl status home-manager-bortemoi.service

sudo systemctl restart home-manager-bortemoi.service
journalctl -fu home-manager-bortemoi.service

Force install all from scratch.
``

```sh
sudo nix run github:nix-community/disko/latest#disko-install -- \
  --flake .#homelab \
  --disk nvme /dev/disk/by-id/nvme-eui.002538b721a05948 \
  --disk hdd1 /dev/disk/by-id/wwn-0x5000c50066b3257f \
  --disk hdd2 /dev/disk/by-id/wwn-0x5000c50065395210 \
  --write-efi-boot-entries
```