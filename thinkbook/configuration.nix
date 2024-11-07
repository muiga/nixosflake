{
  imports =
    [
      ../base/config.nix
      ./hardware.nix
    ];

  # Networking
  networking ={
    hostName = "thinkbook";
  };

}