{ pkgs, ... }: {

  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    defaultEditor = true;

    # settings = {
    #   background = "dark";
    #   history = 5000;
    # };

    plugins = with pkgs.vimPlugins; [
      catppuccin-vim
      vim-easy-align
      zoxide-vim
      fzf-vim
      vim-prettier
      editorconfig-vim
    ];
  };
}
