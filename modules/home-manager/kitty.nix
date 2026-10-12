{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  themes = {
    none = { };
    kanagawa = {
      # Special
      background = "#1F1F28";
      foreground = "#DCD7BA";
      selection_background = "#2D4F67";
      selection_foreground = "#C8C093";
      url_color = "#72A7BC";
      cursor = "#C8C093";
      # Tabs
      active_tab_background = "#1F1F28";
      active_tab_foreground = "#DCD7BA";
      inactive_tab_background = "#1F1F28";
      inactive_tab_foreground = "#C8C093";
      # Normal
      color0 = "#090618";
      color1 = "#C34043";
      color2 = "#76946A";
      color3 = "#C0A36E";
      color4 = "#7E9CD8";
      color5 = "#957FB8";
      color6 = "#6A9589";
      color7 = "#C8C093";
      # Bright
      color8 = "#727169";
      color9 = "#E82424";
      color10 = "#98BB6C";
      color11 = "#E6C384";
      color12 = "#7FB4CA";
      color13 = "#938AA9";
      color14 = "#7AA89F";
      color15 = "#DCD7BA";
      # Extended
      color16 = "#FFA066";
      color17 = "#FF5D62";
    };
  };
  shells = {
    none = { };
    zsh = {
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
in
{
  options.my.kitty.enable = lib.mkEnableOption "Kitty Terminal Emulator";
  options.my.kitty.shell = lib.mkOption {
    type = lib.types.enum (lib.attrNames shells);
    default = "none";
    description = "Shell for Kitty Terminal Emulator.";
  };
  options.my.kitty.theme = lib.mkOption {
    type = lib.types.enum (lib.attrNames themes);
    default = "none";
    description = "Premade theme for Kitty Terminal Emulator.";
  };

  config =
    let
      cfg = config.my.kitty;
    in
    lib.mkIf cfg.enable {
      programs.kitty = {
        enable = true;
        settings = {
          window_padding_width = 0;
        }
        // themes.${cfg.theme}
        // shells.${cfg.shell};
      };
    };
}
