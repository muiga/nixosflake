{ pkgs, lib, ... }:

let
  pkgs_22_11 = import (pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "f7c1500e2eefa58f3c80dd046cba256e10440201";
    hash = "sha256-sDd7QIcMbIb37nuqMrJElvuyE5eVgWuKGtIPP8IWwCc=";
  }) {
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "pcloud"
    ];
  };

  pcloud_22_11 = pkgs_22_11.pcloud.overrideAttrs (prev:
    let
      version = "1.14.0";
      code = "XZpL8AVZAqfCXz5TebJ2gcvAiHi15pYFKPey";
      # Archive link's codes: https://www.pcloud.com/release-notes/linux.html
      src = pkgs.fetchzip {
        url = "https://api.pcloud.com/getpubzip?code=${code}&filename=${prev.pname}-${version}.zip";
        hash = "sha256-uirj/ASOrJyE728q+SB7zq0O9O58XDNzhokvNyca+2c=";
      };

      appimageContents = pkgs.appimageTools.extractType2 {
        name = "${prev.pname}-${version}";
        src = "${src}/pcloud";
      };
    in
    {
      inherit version;
      src = appimageContents;
    });
in

{
  environment.systemPackages = [
    pcloud_22_11
  ];
}
