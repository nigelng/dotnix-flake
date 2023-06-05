{ pkgs, lib, gitConfig, userConfig, ... }: {
  home.packages = [ pkgs.github-copilot-cli ];

  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
      editor = "vim";
      git_protocol = "ssh";
    };
    enableGitCredentialHelper = true;
    extensions = with pkgs; [ gh-eco gh-dash gh-markdown-preview ];
  };

  programs.git = lib.mergeAttrs gitConfig {
    enable = true;
    userName = userConfig.name;
    userEmail = userConfig.email;

    signing = {
      key = userConfig.defaultGpgKey;
      signByDefault = true;
    };

    lfs = {
      enable = true;
      skipSmudge = true;
    };

    extraConfig = {
      user = { "useConfigOnly" = true; };
      init = { "defaultBranch" = "main"; };
      merge = { "conflictstyle" = "diff3"; };
      push = { "autoSetupRemote" = true; };
      core = {
        preloadindex = true;
        fscache = true;
        editor = "vim";
      };
      color = {
        ui = true;
        status = "always";
      };
    };
  };
}
