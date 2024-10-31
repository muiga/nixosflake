{ config, pkgs, ... }:

let
  # Fetch the hostname and construct the path
  hostname = builtins.getEnv "HOSTNAME" or "thinkbook";
  pcsConfigPath = "../${hostname}/configuration.nix";
in

{
  environment.etc."pcs-config.conf".source = pcsConfigPath;

  # Other configuration options...
}
