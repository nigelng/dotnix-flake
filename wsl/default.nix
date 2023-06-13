# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, systemConfig, appConfig, userConfig
, gitConfig, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };

  systemApps = builtins.map (app: builtins.getAttr app pkgs)
    (appConfig.system ++ appConfig.systemWSL ++ appConfig.user);
in {
  ${systemConfig.hostName} =
    home-manager.lib.homeManagerConfiguration { # Currently only host that can be built
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs pkgs systemConfig appConfig userConfig gitConfig;
      };
      modules = [
        ../home/default.nix

        {
          home = {
            username = "${userConfig.user}";
            homeDirectory = "/home/${userConfig.user}";
            packages = [ pkgs.home-manager ] ++ systemApps;
            stateVersion = systemConfig.homeManagerVersion;
          };
        }
      ];
    };
}
