{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  options.my.common.enable = lib.mkEnableOption "Common Apps";

  config = lib.mkIf config.my.common.enable {
    home.packages = with pkgs; [
      firefox
      btop
      vlc
      adwaita-icon-theme
      gnome-themes-extra
      adwaita-qt
      dconf
      systemd
      dust # My favorite `du` alternative.
      parted
      gptfdisk
      sops
      age
      qdirstat
    ];

    # `gtk` also configured to use `adwaita`.
    home.pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
      hyprcursor.enable = true;
      x11.enable = true;
    };

    # I want these `git` settings on literally everything I do.
    programs.git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };

    # My favorite `ls` alternative.
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    # My favorite `sh` alternative.
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      shellAliases = {
        ls = "eza -l";
        du = "dust";
      };
      initContent = ''
        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;3D' backward-word
        bindkey '^[[1;3C' forward-word
        autoload -Uz add-zsh-hook vcs_info
        add-zsh-hook precmd vcs_info
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' unstagedstr '*'
        zstyle ':vcs_info:*' stagedstr '+'
        zstyle ':vcs_info:git:*' formats '[%b%u%c]'
        zstyle ':vcs_info:git:*' actionformats '[%b|%a%u%c]'
        setopt PROMPT_SUBST
        PROMPT='[%n@%m][%~]''${vcs_info_msg_0_}$ '
      '';
    };

    # Force dark (1/?).
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    # Force dark (2/?).
    home.sessionVariables = {
      CHROME_FORCE_DARK_MODE = "1";
      ADW_DISABLE_PORTAL = "0";
      COLORFGBG = "15;0";
    };

    # Force dark (3/?).
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    # Force dark (4/?).
    qt = {
      enable = true;
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita";
      };
    };

    # TODO: Come back to this! So much config to do for common extensions.
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = false;
    };
    # TODO: vscode extensions overlay garbage
    #  https://github.com/nix-community/nix-vscode-extensions/tree/master
    # TODO: via overlay garbage, get kanagawa theme
    #  https://github.com/barklan/kanagawa.vscode
  };
}
