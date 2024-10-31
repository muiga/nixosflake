

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # overlay
  nixpkgs.overlays = [ (self: super: { utillinux = super.util-linux; })];

  # Bootloader.
  boot ={
    kernelPackages = pkgs.linuxPackages_latest;

    # Fix clickpad (clicking by depressing the touchpad).
    kernelParams = [ "psmouse.synaptics_intertouch=0" ];

    loader = {
      systemd-boot = {
        enable =true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

     # Reduce swappiness
    kernel.sysctl = { "swappiness" = 10;};
  };
  # timeout service stop
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';


# Networking
  networking ={
    hostName = "nixos"; # Define your hostname.
      # Enable networking
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 ];
      allowedTCPPortRanges = [ 
        { from = 1714; to = 25000; } # 1714 to 1716 for KDE Connect and 8384 to 22000 for Syncthing
      ];  
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
        { from = 1714; to = 25000; } # 1714 to 1716 for KDE Connect and 22000 to 21027 for Syncthing
      ];
    };
  };

  # Hardware services such as Bluetooth and Sound
  hardware ={
    bluetooth.enable = true;
    pulseaudio.enable = false;
    # hardware accelation
    graphics = {
     enable = true;
     extraPackages = with pkgs; [  
      vaapiVdpau
      libvdpau-va-gl
     ];
     enable32Bit = true;
    };

    # New ThinkPads have a different TrackPoint manufacturer/name.
    trackpoint.device = "TPPS/2 Elan TrackPoint";

    nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;


    prime = {
		  # Make sure to use the correct Bus ID values for your system!
		  intelBusId = "PCI:0:2:0";
		  nvidiaBusId = "PCI:1:0:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
	  };
    };
  };

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  
  # All Services......
  services={

    # Enable the X11 windowing system.
    desktopManager.plasma6.enable = true;	
    displayManager = {
      sddm.enable = true;
      #sddm.theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
      defaultSession = "plasma";
      sddm.wayland.enable = true;
    };

    xserver = {
	    enable = true;
	    xkb.layout = "us";
	    xkb.variant = "";    

      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];

      # Set the right DPI. xdpyinfo says the screen is 677x423 mm but
      # it actually is 344×215 mm.
      monitorSection = lib.mkDefault ''
      DisplaySize 344 215
      '';      
    };

    # postgresql
    postgresql = {
      enable = true;
      package = pkgs.postgresql;
      # dataDir = "~/.data/postgresql";
      # authentication = pkgs.lib.mkOverride 10 ''
      # #type database  DBuser  auth-method
      # local all       all     trust
      # '';
      # authentication = pkgs.lib.mkForce "host all all 127.0.0.1/32 trust";
      # authentication = ''
      #   local all   postgres       peer map=eroot
      # '';
      # identMap = ''
      #   eroot     root      postgres
      #   eroot     postgres  postgres
      # '';
    };  

    # grafana
    # Enable CUPS to print documents.
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.epson-escpr2  ];          # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now. Also no longer need required since server uses ipp to share printer over network.
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns4 = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    # Audio
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    # vpn
    tailscale.enable = true; 

    #Syncthing
    syncthing = {
        enable = true;
        user = "muiga";
        dataDir = "/home/muiga/Sync";    # Default folder for new synced folders
        configDir = "/home/muiga/Sync/.config/syncthing";   # Folder for Syncthing's settings and keys
    };



    # Enable the OpenSSH daemon.
    openssh = {                             # SSH: secure shell (remote connection to shell of server)
      enable = true;                        
      allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)                                            
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';                                   # Temporary extra config so ssh will work in guacamole
    };
    # Enable flatpak
    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
    blueman.enable = true;
    fwupd.enable = true;  
  };

  #theming
  # catppuccin = {
  #   # flavor = "mocha";
  #   # enable = true;
  # };

   # zsh
  programs = {
    dconf.enable = true;
    gamemode.enable = true;
    zsh.enable =true;
     # backlight control
    kdeconnect.enable = true;
    light.enable = true;
    partition-manager.enable = true;
    java.enable = true;
    #Gaming
    steam = {
     enable = true;
     remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };    

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muiga = {
    isNormalUser = true;
    description = "Stephen M Kamau";
    extraGroups = [ "networkmanager" "wheel" "docker" "tailscale"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh-powerlevel10k
      firefox   
      kate
      vlc
      brave      
      inkscape-with-extensions
      insomnia
      haruna
      discord
      motrix
      persepolis
      onedrive
      obs-studio
      # easyeffects
      nodejs_20
      htop
      gwenview
      ferdium
      libreoffice-qt
      pdfarranger
      winbox
      todoist-electron
      megasync
      motrix
      clipgrab
      ffmpeg
      yt-dlp
      epsonscan2
      libva
      libva-utils
      mpv
      smplayer
      filebot
      anydesk
      mellowplayer
      tailscale
      thunderbird-128
      qbittorrent
      shotcut
      clementine
      arduino
      sleuthkit
      bottom
      microsoft-edge
      spotify
      telegram-desktop
      appimage-run
      bruno
      vscode
      protonvpn-gui
      planify
      ticktick
      joplin-desktop
      jetbrains.webstorm
      jetbrains.rust-rover
      gimp
      super-productivity
      nodePackages.prettier
      slack
      spotube
      stremio
      mailspring
      codeium
      dprint
      google-chrome
      jq
    ];
  };


  # Enable sound 
  # sound.enable = true;    
  # security
  security.rtkit.enable = true;
  security.polkit.enable = true;


 
  # virtualisation.docker.enable = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # virtualbox = {
    #   host.enable = true;
    # };
  };

  #
 

  #Fonts
  fonts.packages = with pkgs; [
    inter                
    carlito                                 
    vegur                                  
    source-code-pro
    meslo-lgs-nf
    jetbrains-mono
    font-awesome                            
    corefonts  
    roboto
    roboto-mono
    roboto-serif                             
    (nerdfonts.override {                   
      fonts = [
        "FiraCode"
      ];
    })
  ];

  fonts.fontconfig = {
      enable = true;
      defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
	    serif = [ "Roboto Serif" "Inter" ];
	    sansSerif = [ "Roboto" "Inter"];
      };
  };

  environment = {
    systemPackages = with pkgs;[
      kdePackages.packagekit-qt
      kdePackages.kdenlive
      epson-escpr2
      kdePackages.plasma-nm    
      kdePackages.kruler
      kdePackages.sddm-kcm
      kdePackages.kcolorpicker
      kdePackages.kasts
      kdePackages.sierra-breeze-enhanced
      kdePackages.filelight
      kdePackages.krohnkite
      qt6.qtimageformats
      fwupd
      sbctl
      niv
      android-tools
      polkit
      syncthing
      syncthing-tray
      neofetch
      gitRepo
      wget
      curl
      git
      oh-my-posh
      stow
      fzf
      zoxide
      fzf-git-sh
      eza
      # delta
      bat
      tldr
      thefuck
      fd
    ];
    shells = with pkgs; [
      zsh
    ];
    variables = {
    GDK_SCALE = "1";          
    GDK_DPI_SCALE = "0.8";      
  };
  };


  system = {
    # copySystemConfiguration = true;
    autoUpgrade.enable = true;
    stateVersion = "24.05"; 
  };


  # Allow unfree packages
  nixpkgs.config={
    allowUnfree = true;
    allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
     
  };

  nix = {                                   
    settings ={
      # auto-optimise-store = true;           # Optimise syslinks
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
   
  };

}
