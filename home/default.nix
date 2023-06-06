{ pkgs, systemConfig, appConfig, gitConfig, ... }:
let userApps = builtins.map (app: builtins.getAttr app pkgs) appConfig.user;

in {
  imports = [
    ./direnv.nix
    ./exa.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./shells.nix
    ./ssh.nix
    ./zoxide.nix
    # extensions
    ./home.macos.nix
    ./home.wsl.nix
  ];

  programs = {
    home-manager.enable = pkgs.stdenv.hostPlatform.isDarwin; # Only enable in darwin via nix-darwin
    man.enable = true;
    htop.enable = true;
    dircolors.enable = true;
    macos-home.enable = pkgs.stdenv.hostPlatform.isDarwin;
    wsl-home.enable = pkgs.stdenv.hostPlatform.isLinux;
  };

  editorconfig.enable = true;

  home = {
    stateVersion = systemConfig.homeManagerVersion;
    packages = userApps;

    shellAliases = {
      # Set all shell aliases programatically
      # Aliases for commonly used tools
      grep = "grep --color=auto";
      find = "fd";
      cls = "clear";

      # Nix garbage collection
      garbage = "nix-collect-garbage -d && docker image prune --force";
    };
  };
}
