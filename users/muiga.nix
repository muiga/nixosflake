{pkgs, ...}:

{
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
  home-manager = {
    users.muiga = {
      imports = [../base/home.nix];
    };
#    useUserPackages = true;
  };
}