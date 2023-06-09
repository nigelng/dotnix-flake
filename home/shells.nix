{ lib, pkgs, systemConfig, ... }: {
  programs = {
    exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
      extraOptions = [ "--group-directories-first" "--header" ];
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      colors = {
        "bg+" = "#313244";
        bg = "#1e1e2e";
        fg = "#cdd6f4";
        "fg+" = "#cdd6f4";
        hl = "#f38ba8";
        "hl+" = "#f38ba8";
        spinner = "#f5e0dc";
        header = "#f38ba8";
        info = "#cba6f7";
        pointer = "#f5e0dc";
        marker = "#f5e0dc";
        prompt = "#cba6f7";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };

  # Shell theme with Catpuccin and Starship Prompt
  programs.starship =
    let flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
    in {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        # Other config here
        palette = "catppuccin_${flavour}";
      } // builtins.fromTOML (builtins.readFile (pkgs.fetchurl {
        url = "https://starship.rs/presets/toml/bracketed-segments.toml";
        sha256 = "TdM65nZ/GOaZuy7rkjeuv6Ti9Oa2/gIn0fLy9Y2iKkA=";
      })) // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "starship";
        rev =
          "3e3e54410c3189053f4da7a7043261361a1ed1bc"; # Replace with the latest commit hash
        sha256 = "soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
      } + /palettes/${flavour}.toml));
    };

  # Fish shell
  programs.fish = {
    enable = true;
    shellInit = ''
      # Set syntax highlighting colours; var names defined here:
      # http://fishshell.com/docs/current/index.html#variables-color
      set fish_color_autosuggestion brblack
    '';
    loginShellInit = ''
      # To deal with fish not ordering the nix paths first https://github.com/LnL7/nix-darwin/issues/122
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      # brew path
      eval "$(${systemConfig.brewPrefix}/brew shellenv)"
    '';
    interactiveShellInit = lib.strings.concatStrings
      (lib.strings.intersperse "\n" [
        "set fish_greeting" # disable welcome message
        # (builtins.readFile ./conf.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
        "set fzf_preview_dir_cmd exa --all --color=always"
      ]);

    plugins = with pkgs.fishPlugins; [
      # Themes / Styles
      # { name = "pure"; src = pure.src; }
      {
        name = "hydro";
        src = hydro.src;
      }

      # Plugins
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
      {
        name = "foreign-env";
        src = foreign-env.src;
      }
      {
        name = "pisces";
        src = pisces.src;
      }
      {
        name = "forgit";
        src = forgit.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
      {
        name = "humantime-fish";
        src = humantime-fish.src;
      }
      {
        name = "done";
        src = done.src;
      }
      {
        name = "bass";
        src = bass.src;
      }
    ];
  };

  # Zsh shell
  home.file.".config/zsh/.zimrc".text = ''
    ## Start configuration added by Zim install
    ## This is not sourced during shell startup, and it's only used to configure the
    ## zimfw plugin manager.

    # Modules
    # Sets sane Zsh built-in environment options.
    zmodule environment

    zmodule git
    zmodule input
    zmodule termtitle
    zmodule utility
    zmodule archive

    zmodule duration-info
    zmodule git-info
    zmodule prompt-pwd

  '';

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    history = {
      extended = true;
      share = false;
    };

    historySubstringSearch.enable = true;

    # Called whenever zsh is initialized
    initExtra = ''
      bindkey -e

      ZIM_HOME=''${ZDOTDIR:-$HOME}/.zim

      # Download zimfw plugin manager if missing.
      if [[ ! -e $ZIM_HOME/zimfw.zsh ]]; then
        curl -fsSL --create-dirs -o $ZIM_HOME/zimfw.zsh \
          https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
      fi

      # Install missing modules, and update ''${ZIM_HOME}/init.zsh if missing or outdated.
      if [[ ! $ZIM_HOME/init.zsh -nt ''${ZDOTDIR:-$HOME}/.zimrc ]]; then
        source $ZIM_HOME/zimfw.zsh init -q
      fi

      source $ZIM_HOME/init.zsh

      # Jump to the beginning or the end of the line with alt arrow keys
      bindkey '^A' beginning-of-line # Move back word in lin
      bindkey '^E' end-of-line # Move next word in line

      # Jump between words (Mac OSX default navigation)
      bindkey '^B' backward-word # Move back word in line
      bindkey '^F' forward-word # Move next word in line

      unset key

      # 1P completion
      eval "$(op completion zsh)"; compdef _op op
    '';

    profileExtra = ''
      # brew path
      eval "$(${systemConfig.brewPrefix}/brew shellenv)"
    '';
  };
}

