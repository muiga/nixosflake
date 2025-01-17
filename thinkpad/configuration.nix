{
  imports =
    [
      ../base/config.nix
      ./hardware.nix
      ./disko.nix
    ];

  # Networking
  networking ={
    hostName = "thinkpad";
  };

  services={
    xserver = {
       # Load nvidia driver for Xorg and Wayland
       videoDrivers = ["nvidia"];

       # Set the right DPI. xdpyinfo says the screen is 677x423 mm but
       # it actually is 344×215 mm.
       # monitorSection = lib.mkDefault ''
       # DisplaySize 344 215
       # '';
    };
  };

}