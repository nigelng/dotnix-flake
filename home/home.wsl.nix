{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.wsl-home;
in {
  options.programs.wsl-home = {
    enable = mkEnableOption "the extensions for WSL home-manager";
  };

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 360;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    home.shellAliases = { op = "/usr/bin/op"; };
  };
}

