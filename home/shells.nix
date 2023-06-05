{ pkgs, ... }: {
  # Fish shell
  programs.fish = {
    enable = true;
    shellInit = ''
      # Set syntax highlighting colours; var names defined here:
      # http://fishshell.com/docs/current/index.html#variables-color
      set fish_color_autosuggestion brblack
    '';
    loginShellInit = ''
      # brew path
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
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
        name = "sponge";
        src = sponge.src;
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
      {
        name = "github-copilot-cli-fish";
        src = github-copilot-cli-fish.src;
      }
    ];
  };

  # Zsh shell
  home.file.".config/zsh/.zimrc".source = ./zsh/zimrc;
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
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}

