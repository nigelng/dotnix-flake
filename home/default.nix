{ pkgs, systemConfig, appConfig, gitConfig, userConfig, ... }:
let userApps = builtins.map (app: builtins.getAttr app pkgs) appConfig.user;
in {
  imports = [
    ./git.nix
    ./shells.nix
    ./vim.nix
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

      extraConfig = let
        idAgent = if pkgs.stdenv.hostPlatform.isDarwin then
          ''
            IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
        else
          "";
      in ''
        ${idAgent}

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
      op = "/usr/local/bin/op";

      Gf = "git fetch";
      Ga = "git add";
      Gb = "git branch";
      Gc = "git commit";
      Gco = "git checkout";
      Gcg = "git gc";
      Gp = "git push";
      Gr = "git rebase";
      Gs = "git status";
      Gt = "git tag";
      Gl =
        "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";

      # Nix garbage collection
      garbage = "nix-collect-garbage -d && docker image prune --force";

      load_gh_token =
        "export NODE_AUTH_TOKEN=$(/usr/local/bin/op item get 245emzlxcgvgpkwp6cwcsxidhe --fields label=token) >> /dev/null";
    };
  };
}
