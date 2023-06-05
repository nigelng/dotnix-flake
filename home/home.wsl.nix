{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.wsl-home;
in {
  options.programs.wsl-home = {
    enable = mkEnableOption "the extensions for WSL home-manager";
    package = mkPackageOption pkgs "pinentry" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 360;
      enableFishIntegration = true;
      enableZshIntegration = true;
      pinentryFlavor = "${pkgs.pinentry}";
    };
  };
}

