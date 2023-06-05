{ pkgs, userConfig, ... }: {
  programs.gpg = {
    enable = true;
    settings = {
      default-key = userConfig.defaultGpgKey;
      keyserver-options = "include-revoked";
    };
  };
}
