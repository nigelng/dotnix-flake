{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.macos-home;
in {
  options.programs.macos-home = {
    enable = mkEnableOption "the extensions for macOS home-manager";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      darwinLaunchOptions = [ "--single-instance" ];
      #font = "BlexMono Nerd Font";
      environment = { };
      settings = {
        scrollback_lines = 50000;
        enable_audio_bell = false;
        font_family = "BlexMono Nerd Font";
        bold_font = "BlexMono Nerd Font Bold";
        italic_font = "BlexMono Nerd Font Italic";
        bold_italic_font = "BlexMono Nerd Font Bold Italic";

        bell_on_tab = "🔔 ";
        font_size = "15.0";
        adjust_line_height = "120%";

        background_opacity = "0.95";
        window_padding_width = "2.5";
        window_border_width = 0;

        titlebar-only = "yes";
      };
      theme = "Catppuccin-Mocha";
      # extraConfig = "" "";
    };
  };
}
