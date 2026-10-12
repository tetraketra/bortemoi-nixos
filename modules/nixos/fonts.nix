{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  config = {
    fonts.packages = with pkgs; [
      liberation_ttf
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fonts.fontconfig = {
      defaultFonts = {
        serif = [
          "Liberation Serif"
        ];
        sansSerif = [
          "Liberation Sans"
        ];
        monospace = [
          "JetBrains Mono"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
