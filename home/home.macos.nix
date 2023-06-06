{ config, lib, ... }:
with lib;
let cfg = config.programs.macos-home;
in {
  options.programs.macos-home = {
    enable = mkEnableOption "the extensions for macOS home-manager";
  };

  config = mkIf cfg.enable {
    home.file = { ".gnupg/gpg-agent.conf".source = ./macos/gpg-agent-conf; };
    programs.kitty = {
      enable = true;
      darwinLaunchOptions = [ "--single-instance" ];
      #font = "JetBrainsMono Nerd Font";
      environment = { };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        font_family = "JetBrainsMono Nerd Font Mono Medium";
        bold_font = "JetBrainsMono Nerd Font Mono Bold";
        italic_font = "JetBrainsMono Nerd Font Mono Italic";
        bold_italic_font = "JetBrainsMono Nerd Font Mono Bold Italic";

        font_size = "16.0";
        adjust_line_height = "110%";

        bell_on_tab = "🔔 ";

        window_padding_width = "4.0";
      };
      theme = "Catppuccin-Mocha";
      # extraConfig = "" "";
    };
  };
}
