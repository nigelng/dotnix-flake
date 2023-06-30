{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.wsl-home;
in {
  options.programs.wsl-home = {
    enable = mkEnableOption "the extensions for WSL home-manager";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = { AWS_VAULT_BACKEND = "pass"; };
      shellAliases = { op = "/usr/bin/op"; };
    };

    programs.password-store = { enable = true; };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 360;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}

