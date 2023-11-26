

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
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  # hardware accelation
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [  
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  networking ={
    hostName = "nixos"; # Define your hostname.
      # Enable networking
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 ];
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  
  services={
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


    # Enable the X11 windowing system.
    xserver = {
	    enable = true;
	    layout = "us";
	    # xkbVariant = "";
      displayManager = {
	      sddm.enable = true;
        sddm.theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
  	    defaultSession = "plasmawayland";
      };
      desktopManager.plasma5.enable = true;	
    };
    # Enable CUPS to print documents.
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.epson-escpr2  ];          # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now. Also no longer need required since server uses ipp to share printer over network.
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      #media-session.enable = true;
    };
    tailscale.enable = true; 
    # Enable the OpenSSH daemon.
    openssh = {                             # SSH: secure shell (remote connection to shell of server)
      enable = true;                        # local: $ ssh <user>@<ip>
                                            # public:
                                            #   - port forward 22 TCP to server
                                            #   - in case you want to use the domain name insted of the ip:
                                            #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
                                            #   - connect via ssh <user>@<ip or ssh.domain>
                                            # generating a key:
                                            #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
                                            #   - if ssh-add does not work: $ eval `ssh-agent -s`
      allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)
                                            # connect: $ sftp <user>@<ip/domain>
                                            #   or with file browser: sftp://<ip address>
                                            # commands:
                                            #   - lpwd & pwd = print (local) parent working directory
                                            #   - put/get <filename> = send or receive file
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';                                   # Temporary extra config so ssh will work in guacamole
    };
    # Enable flatpak
    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
  };
# all hardaware
  hardware ={
    pulseaudio.enable = false;
  };

#enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.fwupd.enable = true;

  # Enable sound 
  sound.enable = true;
  # security
  security.rtkit.enable = true;
  security.polkit.enable = true;
 
  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muiga = {
    isNormalUser = true;
    description = "Stephen M Kamau";
    extraGroups = [ "networkmanager" "wheel" "docker" "tailscale"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh-powerlevel10k
      firefox   
      git 
      firefox
      kate
      vscode
      vlc
      brave
      git
      curl
      thunderbird
      betterbird
      latte-dock
      inkscape-with-extensions
      insomnia
      haruna
      discord
      motrix
      persepolis
      lightly-qt
      sierra-breeze-enhanced
      onedrive
      obs-studio
      easyeffects
      nodejs_18
      htop
      gwenview
      ferdium
      rambox
      libreoffice
      pdfarranger
      winbox
      todoist-electron
      megasync
      motrix
      clipgrab
      ffmpeg
      youtube-dl
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
      handbrake
      qbittorrent
      joplin-desktop
      shotcut
      clementine
      arduino
    ];

    
  };

  # zsh and ohmyzsh
  programs = {
    dconf.enable = true;
    zsh.enable =true;
     # backlight control
    light.enable = true;
  };

  #Fonts
  fonts.packages = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    meslo-lgs-nf
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    systemPackages = with pkgs;[
      libsForQt5.packagekit-qt
      libsForQt5.bismuth
      libsForQt5.kdenlive
      libsForQt5.sddm-kcm
      libsForQt5.kdeconnect-kde
      epson-escpr2
      libsForQt5.plasma-nm
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.soundkonverter
      libsForQt5.kruler
      fwupd
      sbctl
      niv
    ];
    shells = with pkgs; [
      zsh
    ];
  };
  system.stateVersion = "23.05"; # Did you read the comment?
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
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
