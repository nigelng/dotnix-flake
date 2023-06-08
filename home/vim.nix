{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
      history = 5000;
    };
    plugins = with pkgs; [
      vimPlugins.catppuccin-vim
      vimPlugins.vim-easy-align
      vimPlugins.zoxide-vim
      vimPlugins.fzf-vim
      vimPlugins.vim-prettier
      vimPlugins.editorconfig-vim
    ];
  };
}
