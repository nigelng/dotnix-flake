{ pkgs, systemConfig, ... }:
let
  systemFonts =
    builtins.map (app: builtins.getAttr app pkgs) systemConfig.fonts;
  nerdFonts = with pkgs;
    [ (nerdfonts.override { fonts = systemConfig.nerdFonts; }) ];
in {
  system = {
    stateVersion = 4;

    keyboard = { enableKeyMapping = true; };

    defaults = {
      NSGlobalDomain = {
        # expand the save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # Disable automatic typography options I find annoying while typing code
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;

        # enable tap-to-click (mode 1)
        "com.apple.mouse.tapBehavior" = 1;

        # Enable full keyboard access for all controls
        # (e.g. enable Tab in modal dialogs)
        AppleKeyboardUIMode = 3;

        # Set a very fast keyboard repeat rate
        KeyRepeat = 2;
        InitialKeyRepeat = 10;

        # Enable subpixel font rendering on non-Apple LCDs
        # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
        # AppleFontSmoothing = 1;

        # Finder: show all filename extensions
        AppleShowAllExtensions = true;
      };

      finder = {
        # show full POSIX path as Finder window title
        _FXShowPosixPathInTitle = true;
        # disable the warning when changing a file extension
        FXEnableExtensionChangeWarning = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
        TrackpadRightClick = true;
      };

      dock = {
        tilesize = 48;
        orientation = "bottom";
        show-process-indicators = true;

        # enable spring loading (hold a dragged file over an icon to drop/open it there)
        enable-spring-load-actions-on-all-items = true;
        # don't automatically rearrange spaces based on the most recent one
        mru-spaces = false;
      };

      screencapture.location = systemConfig.screenshotFolder;
    };
  };

  # fonts
  fonts = {
    fontDir.enable = true;
    fonts = systemFonts ++ nerdFonts;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
