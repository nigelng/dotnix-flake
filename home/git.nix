{ lib, pkgs, gitConfig, userConfig, ... }:
with lib; {
  home.packages = [ pkgs.github-copilot-cli ];

  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
      editor = "vim";
      git_protocol = "https";
    };
    enableGitCredentialHelper = true;
    extensions = with pkgs; [ gh-eco gh-dash gh-markdown-preview ];
  };

  programs.git = mergeAttrs gitConfig {
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
