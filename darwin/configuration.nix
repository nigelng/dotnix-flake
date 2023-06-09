{ config, pkgs, appConfig, systemConfig, userConfig, ... }:
let
  systemApps = builtins.map (app: builtins.getAttr app pkgs)
    (appConfig.system ++ appConfig.systemMac);

in {
  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [ userConfig.user ] ++ systemConfig.trustedUsers;
      allowed-users = [ userConfig.user ] ++ systemConfig.allowedUsers;
    };

    gc = {
      # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    computerName = systemConfig.computerName;
    hostName = systemConfig.hostName;
  };

  environment = {
    systemPackages = systemApps;
    shells = with pkgs; [ fish zsh ];
    variables = {
      EDITOR = "vim";
      VISUAL = "code";
      CHROME_EXECUTABLE =
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser";
    };
  };

  programs = {
    zsh.enable = true;
    fish.enable = true;
    gnupg.agent.enable = true;
  };

  services = { nix-daemon.enable = true; };

  homebrew = {
    enable = true;
    brews = appConfig.brew;
    casks = appConfig.cask;
    brewPrefix = systemConfig.brewPrefix;
    global = { brewfile = true; };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = false;
    };
    masApps = appConfig.mas;
  };

  users.users."${userConfig.user}" = {
    # name = currentUser;
    home = "/Users/${userConfig.user}";
    shell = pkgs.fish;
  };

  system.activationScripts.extraActivation.text = ''
    cp ${pkgs._1password}/bin/op /usr/local/bin/op
  '';
}
