{pkgs, ...}:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muiga = {
    isNormalUser = true;
    description = "Stephen M Kamau";
    extraGroups = [ "networkmanager" "wheel" "docker" "tailscale"];
    shell = pkgs.zsh;
  };
  home-manager = {
    users.muiga = {
      imports = [../base/home.nix];
    };
  };
}