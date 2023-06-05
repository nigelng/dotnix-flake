# flake.nix *
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./wsl
#       └─ default.nix
#
{
  description = "Personal flake configs for various setup";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      baseConfig = {
        url = "path:./config";
        flake = false;
      };

      mahConfig.url = "git+ssh://git@github.com/nigelng/dotnix-config?ref=main";
      mahConfig.inputs.mahConfig.follows = "baseConfig";

      nixpkgs.url =
        "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages

      nixpkgs-stable.url =
        "github:nixos/nixpkgs/nixos-23.05"; # Stable Nix Packages

      home-manager = { # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, darwin
    , mahConfig, ...
    }: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      appConfig =
        builtins.fromJSON (builtins.readFile "${mahConfig}/config/apps.json");
      systemConfig =
        builtins.fromJSON (builtins.readFile "${mahConfig}/config/system.json");
      userConfig =
        builtins.fromJSON (builtins.readFile "${mahConfig}/config/user.json");
      gitConfig =
        builtins.fromJSON (builtins.readFile "${mahConfig}/config/git.json");
    in {
      darwinConfigurations = ( # Darwin Configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable home-manager darwin;
          inherit appConfig systemConfig userConfig gitConfig;
        });

      # homeConfigurations = ( # Non-NixOS configurations
      #   import ./nix {
      #     inherit (nixpkgs) lib;
      #     inherit inputs nixpkgs nixpkgs-stable home-manager user;
      #   });
    };
}