# These are the profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#

{ inputs, nixpkgs, nixpkgs-stable, home-manager, darwin, systemConfig, appConfig
, userConfig, gitConfig, ... }:

let
  system = "aarch64-darwin"; # M-series chip

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };
in {
  ${systemConfig.hostName} = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs stable systemConfig appConfig userConfig;
    };
    modules = [ # Modules that are used
      ./configuration.nix
      ./system.nix

      home-manager.darwinModules.home-manager
      { # Home-Manager module that is used
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit systemConfig appConfig userConfig gitConfig;
        }; # Pass flake variable
        home-manager.users.${userConfig.user} = import ../home;
      }
    ];
  };
}
