{
  fonts = import ./fonts.nix;
  forgejo = import ./forgejo.nix;
  adguardhome = import ./adguardhome.nix;
  caddy = import ./caddy.nix;
  common = import ./common.nix;
}
