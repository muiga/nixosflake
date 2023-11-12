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
                modules = [./configuration.nix];
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