{
  inputs,
  outputs,
  stateVersion,
  ...
}:
{
  # Helper function for generating home-manager configs
  mkHome =
    {
      hostname,
      username ? "muiga",
      desktop ? null,
      platform ? "x86_64-linux",
    }:
    let
      #isISO = builtins.substring 0 4 hostname == "iso-";
      #isInstall = !isISO;
      isLaptop = hostname == "thinkpad" || hostname == "nixos" || hostname == "thinkbook";
      #isLima = hostname == "blackace" || hostname == "defender" || hostname == "fighter";
      #isWorkstation = builtins.isString desktop;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isLaptop
          isLima
          isISO
          isWorkstation
          ;
      };
      modules = [ ../home-manager ];
    };

  # Helper function for generating NixOS configs
  mkNixos =
    {
      hostname,
      username ? "muiga",
      desktop ? null,
      platform ? "x86_64-linux",
    }:
    let
      #isISO = builtins.substring 0 4 hostname == "iso-";
      #isInstall = !isISO;
      isLaptop = hostname == "thinkpad" || hostname == "nixos" || hostname == "thinkbook";
      #isWorkstation = builtins.isString desktop;
      #tailNet = "drongo-gamma.ts.net";
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isISO
          isLaptop
          isWorkstation
          tailNet
          ;
      };
      # If the hostname starts with "iso-", generate an ISO image
      modules =
        let
          cd-dvd =
            if (desktop == null) then
              inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            else
              inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix";
        in
        [ ../nixos ] ++ inputs.nixpkgs.lib.optionals isISO [ cd-dvd ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"   
  ];
}