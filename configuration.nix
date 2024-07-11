

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot ={
    kernelPackages = pkgs.linuxPackages_latest;
    # Video drivers
    initrd.kernelModules = [ "amdgpu" ];  
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

        #Auto-CPUFreq for power management on Laptops
    # auto-cpufreq.enable = true;

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
      easyeffects
      nodejs_20
      htop
      gwenview
      ferdium
      rambox
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
      ngrok  
      anydesk
      mellowplayer
      tailscale
      thunderbird
      qbittorrent
      shotcut
      clementine
      arduino
      sleuthkit
      bottom
      microsoft-edge
      spotify
      telegram-desktop
      bitwarden
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
    ];
  };


  # Enable sound 
  sound.enable = true;    
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
      libsForQt5.polonium
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
      delta
      bat
      tldr
      # thefuck
      fd
    ];
    shells = with pkgs; [
      zsh
    ];
  };


  system = {
    # copySystemConfiguration = true;
    autoUpgrade.enable = true;
    stateVersion = "24.05"; # Defines whether the base is based on the point releases or the unstable release
  };


  # Allow unfree packages
  nixpkgs.config={
    allowUnfree = true;
    allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
    # permittedInsecurePackages = [
    #   "freeimage-unstable-2021-11-01"
    # ];
   
  };

  nix = {                                   # Nix Package Manager settings
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
