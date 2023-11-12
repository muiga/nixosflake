{ config, pkgs, ... }:
let 
  myAliases ={
    upgrade-system = "sudo nixos-rebuild switch --flake ~/.dotfiles";
    upgrade-home = "home-manager switch --flake ~/.dotfiles";
    update-pkgs = "cd ~/.dotfiles && nix flake update && cd";
  };

in
{

  home.username = "muiga";
  home.homeDirectory = "/home/muiga";
  home.stateVersion = "23.05"; # Please read the comment before changing.
    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
 
      firefox
      kate
      vscode
      vlc
      brave
      git
      curl
      thunderbird
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
      protonvpn-gui
      mellowplayer
      tailscale
      handbrake
      qbittorrent
      joplin-desktop
      shotcut
      clementine
];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/muiga/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    enable = true;
    userName  = "muiga";
    userEmail = "muigask@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    shellAliases = myAliases;
    plugins=[
        {
    name = "powerlevel10k";
    src = pkgs.zsh-powerlevel10k;
    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }  
    ];
    initExtra = '' 
      source ./.p10k.zsh
    '';
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";    
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
