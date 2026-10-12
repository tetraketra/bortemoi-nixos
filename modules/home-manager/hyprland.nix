{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  options.my.hyprland.enable = lib.mkEnableOption "Hyprland Compositor";
  options.my.hyprland.noctalia.enable = lib.mkEnableOption "Noctalia integration.";

  config = lib.mkIf config.my.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        monitor = [
          # TODO: Configurable. This is only a thing on my homelab.
          "HDMI-A-2, preferred, auto, 1, transform, 2"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 0;
        };

        general = {
          gaps_in = 1.8;
          gaps_out = 3;
          layout = "dwindle";
          resize_on_border = true;
          border_size = 1;
          extend_border_grab_area = 10;
          "col.active_border" = "rgba(98BB6Cff)";
          "col.inactive_border" = "rgba(54546Dff)";
        };

        misc.disable_hyprland_logo = true;
        ecosystem.no_update_news = true;

        "$mod" = "SUPER";

        "exec-once" = if config.my.hyprland.noctalia.enable then [ "noctalia" ] else [ ];

        bind = [
          "$mod, RETURN, exec, kitty"
          "$mod SHIFT, T, exec, kitty"
          "$mod, Q, killactive"
          "$mod, LEFT, movefocus, l"
          "$mod, RIGHT, movefocus, r"
          "$mod, UP, movefocus, u"
          "$mod, DOWN, movefocus, d"
          "$mod SHIFT, LEFT, movewindow, l"
          "$mod SHIFT, RIGHT, movewindow, r"
          "$mod, J, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, I, movefocus, u"
          "$mod, K, movefocus, d"
          "$mod SHIFT, Q, exit"
          "$mod SHIFT, Tab, workspace, -1"
          "$mod, Tab, workspace, +1"
        ]
        ++ (
          if config.my.hyprland.noctalia.enable then
            [
              "$mod CTRL, S, exec, noctalia msg panel-toggle launcher"
            ]
          else
            [ ]
        );
      };
    };
  };
}
