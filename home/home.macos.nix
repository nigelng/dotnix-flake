{ config, lib, ... }:
with lib;
let cfg = config.programs.macos-home;
in {
  options.programs.macos-home = {
    enable = mkEnableOption "the extensions for macOS home-manager";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".gnupg/gpg-agent.conf".source = ./macos/gpg-agent-conf;
      ".config/terminal/my.terminal".source = ./macos/terminal-theme;
    };
  };
}
