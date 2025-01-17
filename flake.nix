{
    description = "My Awesome flake";


    inputs ={
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lanzaboote.url ="github:nix-community/lanzaboote/v0.4.1";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
        nixpkgs-unfree = {
            url = "github:numtide/nixpkgs-unfree";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        disko={
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


   outputs = { self, nixpkgs,lanzaboote,disko, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";     
        specialArgs = { inherit inputs system; };
        shared-modules = [
            home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            #lanzaboote.nixosModules.lanzaboote
            {
              home-manager = {
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "backup";
              };
            }
        ];
    in {

        # NixOS configuration entrypoint
        nixosConfigurations = {
            thinkpad= nixpkgs.lib.nixosSystem {
                specialArgs = specialArgs;
                system = system;
                modules = shared-modules ++
                [
                    ({ pkgs, inputs, ... }: {
                    imports = [
                        ./thinkpad/configuration.nix
                    ];
                    })

                    # Lanzaboote for secure boot
                #    ({ pkgs, lib, ... }: {
                #         #environment.systemPackages = [
                #           # For debugging and troubleshooting Secure Boot.
                #           #pkgs.sbctl
                #         #];
                #         boot.loader.systemd-boot.enable = lib.mkForce false;
                #         boot.lanzaboote = {
                #             enable = true;
                #             pkiBundle = "/etc/secureboot";
                #             configurationLimit = 5;
                #        };
                #    })
                ];
            };
            thinkbook= nixpkgs.lib.nixosSystem {
                specialArgs = specialArgs;
                system = system;
                modules = shared-modules ++
                [
                    ({ pkgs, inputs, ... }: {
                    imports = [
                        ./thinkbook/configuration.nix
                    ];
                    })

                    # Lanzaboote for secure boot
                   #({ pkgs, lib, ... }: {
                        # Lanzaboote currently replaces the systemd-boot module.
                        # This setting is usually set to true in configuration.nix
                        # generated at installation time. So we force it to false
                        # for now.
                       # boot.loader.systemd-boot.enable = lib.mkForce false;
                       # boot.lanzaboote = {
                        #    enable = true;
                        #    pkiBundle = "/etc/secureboot";
                        #    configurationLimit = 5;

                       #};
                   #})
                ];
            };
        };
    };
}