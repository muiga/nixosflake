{
    description = "My first flake";


    inputs ={
        nixpkgs.url="nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        lanzaboote.url ="github:nix-community/lanzaboote/v0.3.0";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    };


    outputs ={self, nixpkgs, home-manager, lanzaboote, ...}:

    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in {
        nixosConfigurations = {
            nixos= lib.nixosSystem {
                inherit system;
                modules = [
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
                        };
                    })
                 ];
            };

        };
        homeConfigurations = {
             muiga= home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [./home.nix];
            };
        };
    };
}