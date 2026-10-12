{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  myWallpaper = ../../dotfiles/wallpapers/kanagawa-street.jpg;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my.noctalia.enable = lib.mkEnableOption "Noctalia Shell";

  config = lib.mkIf config.my.noctalia.enable {
    services = {
      mako.enable = true;
      swayidle.enable = true;
      polkit-gnome.enable = true;
    };

    programs = {
      fuzzel.enable = true;
      swaylock.enable = true;
      waybar.enable = true;

      noctalia = {
        enable = true;
        settings = {
          accessibility = {
            ui_scale = 0.75;
          };

          bar = {
            density = "comfortable";
            position = "top";
            default = {
              center = [
                "date"
                "clock"
              ];
              end = [
                "media"
                "tray"
                "notifications"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "control-center"
                "settings"
                "session"
              ];
              margin_ends = 0;
              padding = 13;
              position = "left";
              radius = 0;
              scale = 0.8;
              shadow = false;
            };
          };

          desktop_widgets = {
            enabled = false;
          };

          dock = {
            enabled = false;
          };

          lockscreen_widets = {
            enabled = false;
          };

          shell = {
            corner_radius_scale = 0.15;
            external_ip_enabled = true;
            font_family = "JetBrainsMono Nerd Font";
            lang = "en";
            panel_anchor_bar = "default";
            popup_shadows = false;
            telemetry_enabled = false;
            animations = {
              enabled = false;
            };
            shadow = {
              alpha = 0.0;
            };
          };

          theme = {
            builtin = "Kanagawa";
            shell_mode = "dark";
          };

          wallpaper = {
            enabled = true;
            fill_mode = "crop";
            default = {
              path = "${myWallpaper}";
            };
          };

          widget = {
            date = {
              anchor = true;
              format = "{:%Y %m %d}";
              timezone = "America/New_York";
            };
          };
        };
      };
    };
  };
}
