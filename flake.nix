{
    description = "My first flake";


    inputs ={
        nixpkgs.url="nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        lanzaboote.url ="github:nix-community/lanzaboote/v0.3.0";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
        
    };


    outputs ={self, nixpkgs, nixpkgs-unstable, home-manager, lanzaboote, ...}:

    let
        system = "x86_64-linux";
        overlay-nixpkgs = final: prev: {       
            unstable = import nixpkgs-unstable {
                inherit system;
            config.allowUnfree = true;
            };
        };
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${system};
    in {
   

        # NixOS configuration entrypoint
        nixosConfigurations = {
            nixos= lib.nixosSystem {
                inherit system;
                modules = [
                    ({ config, pkgs, ... }: {
                        nixpkgs.overlays = [ overlay-nixpkgs ];
                    })
                    ./configuration.nix
                    # This is not a complete NixOS configuration and you need to reference
                    # your normal configuration here.

                    lanzaboote.nixosModules.lanzaboote
                   ({ pkgs, lib, ... }: {
                        # Lanzaboote currently replaces the systemd-boot module.
                        # This setting is usually set to true in configuration.nix
                        # generated at installation time. So we force it to false
                        # for now.
                        boot.loader.systemd-boot.enable = lib.mkForce false;
                        boot.lanzaboote = {
                            enable = true;
                            pkiBundle = "/etc/secureboot";
                            configurationLimit = 5;

                       };
                   })
                 ];
            };

        };

        # Standalone home-manager configuration entrypoint
        homeConfigurations = {
             muiga= home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [./home.nix];
            };
        };
    };
}
