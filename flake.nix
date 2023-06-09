# flake.nix *
#   ├── ./config
#   │   ├─ ./apps.json      # Apps needed to be installed
#   │   ├─ ./system.json    # System details
#   │   ├─ ./user.json      # Current user details
#   │   └─ ./git.json       # Git config
#   │
#   ├── ./darwin
#   │   ├─ ./default.nix *
#   │   ├─ configuration.nix
#   │   └─ system.nix
#   │
#   ├── ./home
#   │   ├─ ./default.nix *  # Imports all below nix
#   │   ├─ direnv.nix
#   │   ├─ exa.nix
#   │   ├─ fzf.nix
#   │   ├─ git.nix
#   │   ├─ gpg.nix
#   │   ├─ home.macosx.nix  # MacOS specific
#   │   ├─ home.wsl.nix     # WSL specific
#   │   ├─ shells.nix
#   │   ├─ ssh.nix
#   │   └─ zoxide.nix
#   │
#   └── ./wsl
#       └─ default.nix
#

{
  description = "Personal flake configs for various setup";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      baseConfig = {
        url = "git+file:./config";
        flake = false;
      };

      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # Unstable Nix Packages

      home-manager = { # User Package Management
        url = "github:nix-community/home-manager?ref=release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, baseConfig, ...
    }: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      appConfig =
        builtins.fromJSON (builtins.readFile "${baseConfig}/config/apps.json");
      systemConfig = builtins.fromJSON
        (builtins.readFile "${baseConfig}/config/system.json");
      userConfig =
        builtins.fromJSON (builtins.readFile "${baseConfig}/config/user.json");
      gitConfig =
        builtins.fromJSON (builtins.readFile "${baseConfig}/config/git.json");
    in {
      darwinConfigurations = ( # Darwin Configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin;
          inherit appConfig systemConfig userConfig gitConfig;
        });

      homeConfigurations = ( # Non-NixOS configurations
        import ./wsl {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
          inherit appConfig systemConfig userConfig gitConfig;
        });
    };
}
