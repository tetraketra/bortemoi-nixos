run-vm config:
    git add . && git commit -am "none(none) flake sync"
    find . -type f -name '*.qcow2' -delete
    nix run .#nixosConfigurations.{{config}}.config.system.build.vm --show-trace
set-owner user path:
    sudo setfacl -R -m u:{{user}}:rwx {{path}}
    sudo setfacl -R -d -m u:{{user}}:rwx {{path}}
