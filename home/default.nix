{ pkgs, systemConfig, appConfig, gitConfig, userConfig, ... }:
let userApps = builtins.map (app: builtins.getAttr app pkgs) appConfig.user;

in {
  imports = [
    ./git.nix
    ./shells.nix
    # extensions
    ./home.macos.nix
    ./home.wsl.nix
  ];

  programs = {
    dircolors.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
      settings = {
        default-key = userConfig.defaultGpgKey;
        keyserver-options = "include-revoked";
      };
    };
    htop.enable = true;
    man.enable = true;
    ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "~/.ssh/ssh-control-%r@%h:%p";
      controlPersist = "5m";

      extraConfig = ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };

    # System specific
    macos-home.enable = pkgs.stdenv.hostPlatform.isDarwin;
    wsl-home.enable = pkgs.stdenv.hostPlatform.isLinux;
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 80;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  home = {
    stateVersion = systemConfig.homeManagerVersion;
    packages = userApps;

    shellAliases = {
      # Set all shell aliases programatically
      # Aliases for commonly used tools
      grep = "grep --color=auto";
      find = "fd";
      cls = "clear";
      wo = "cd ~/Workspaces";

      # Nix garbage collection
      garbage = "nix-collect-garbage -d && docker image prune --force";
    };
  };
}
