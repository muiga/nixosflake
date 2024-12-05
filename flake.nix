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
    };


   outputs = { self, nixpkgs,lanzaboote, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";     
        specialArgs = { inherit inputs system; };
        shared-modules = [
            home-manager.nixosModules.home-manager
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
                    # main config file
                    # ./thinkpad/configuration.nix

                    # Pass `inputs` to configuration.nix
                    ({ pkgs, inputs, ... }: {
                    imports = [
                        ./thinkpad/configuration.nix
                    ];
                    })

                    # Lanzaboote for secure boot
                    lanzaboote.nixosModules.lanzaboote
                   ({ pkgs, lib, ... }: {
                        #environment.systemPackages = [
                          # For debugging and troubleshooting Secure Boot.
                          #pkgs.sbctl
                        #];
                        boot.loader.systemd-boot.enable = lib.mkForce false;
                        boot.lanzaboote = {
                            enable = true;
                            pkiBundle = "/etc/secureboot";
                            configurationLimit = 5;
                       };
                   })
                ];
            };
            thinkbook= nixpkgs.lib.nixosSystem {
                specialArgs = specialArgs;
                system = system;
                modules = shared-modules ++
                [
                    # main config file
                    ./thinkbook/configuration.nix
                    # This is not a complete NixOS configuration and you need to reference
                    # your normal configuration here.

                    # Lanzaboote for secure boot
                    #lanzaboote.nixosModules.lanzaboote
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

#        # Standalone home-manager configuration entrypoint
#        homeConfigurations = {
#             "muiga@thinkpad"= home-manager.lib.homeManagerConfiguration {
#                inherit pkgs;
#                modules = [
#                    ./thinkpad/home.nix
#                ];
#            };
#            "muiga@thinkbook"= home-manager.lib.homeManagerConfiguration {
#                inherit pkgs;
#                modules = [
#                    ./thinkbook/home.nix
#                ];
#            };
#        };
    };
}