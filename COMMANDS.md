Run VM
> nix run .#nixosConfigurations.homelab.config.system.build.vm

Investigate home-manager errors on the VM
> systemctl status home-manager-bortemoi.service
> 
> sudo systemctl restart home-manager-bortemoi.service
> journalctl -fu home-manager-bortemoi.service