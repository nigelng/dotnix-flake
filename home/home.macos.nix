{ config, lib, pkgs, userConfig, ... }:
with lib;
let
  cfg = config.programs.macos-home;
  chromiumExtensions = userConfig.chromiumExtensions;
in {
  options.programs.macos-home = {
    enable = mkEnableOption "the extensions for macOS home-manager";
  };

  config = mkIf cfg.enable {
    home = {
      file.".config/kitty/tab_bar.py".source = ./macos/kitty_tab_bar_py;
      shellAliases = { op = "/usr/local/bin/op"; };
    };

    programs.home-manager.enable = true; # Only enable in darwin via nix-darwin

    programs.brave = {
      enable = false;
      extensions = chromiumExtensions;
    };

    programs.kitty = {
      enable = true;
      darwinLaunchOptions = [ "--single-instance" ];
      environment = { };
      settings = {
        scrollback_lines = 5000;
        enable_audio_bell = false;
        font_family = "BlexMono Nerd Font";
        bold_font = "BlexMono Nerd Font Bold";
        italic_font = "BlexMono Nerd Font Italic";
        bold_italic_font = "BlexMono Nerd Font Bold Italic";

        font_size = "16.0";
        adjust_line_height = "120%";

        background_opacity = "0.95";
        window_padding_width = "3";
        window_border_width = 0;

        titlebar-only = "yes";

        bell_on_tab = "no";

        tab_bar_edge = "bottom";
        tab_bar_align = "left";
        tab_bar_style = "custom";
        tab_bar_min_tabs = 1;

        tab_activity_symbol = "none";
        tab_separator = "";
        tab_bar_margin_width = "0.0";
        tab_bar_margin_height = "0.0 0.0";
        tab_title_template =
          "{f'{title[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (title.center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else title.center(5))}";
        active_tab_font_style = "bold";
      };

      theme = "Catppuccin-Mocha";
    };
  };
}
