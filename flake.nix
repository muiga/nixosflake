{
    description = "My Awesome flake";


    inputs ={
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lanzaboote.url ="github:nix-community/lanzaboote/v0.3.0";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    };


    outputs ={self, nixpkgs, home-manager, 
        lanzaboote, ...
        }:

    let
        system = "x86_64-linux";     
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${system};
    in {
   

        # NixOS configuration entrypoint
        nixosConfigurations = {
            nixos= lib.nixosSystem {
                inherit system;
                modules = [                    
                    # main config file
                    ./configuration.nix
                    # This is not a complete NixOS configuration and you need to reference
                    # your normal configuration here.
                   

                    # Lanzaboote for secure boot
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
