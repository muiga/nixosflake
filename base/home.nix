{ pkgs, ... }:
let
  myAliases ={
    upgrade = "cd /etc/nixos && sudo nix flake update && cd && sudo nixos-rebuild switch";
    update="cd /etc/nixos && sudo nix flake update && cd";
    clean-home = "nix-collect-garbage -d";
    clean-system = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    psql-u ="sudo -u postgres psql";
    connect-ec2 = "ssh -i ~/.ssh/i-keys.pem ubuntu@ec2-3-76-209-240.eu-central-1.compute.amazonaws.com";
    connect-contabo-prod = "ssh root@144.91.119.192";
    connect-contabo-mine = "ssh root@45.159.222.167";
    codium-ai = "sh /etc/nixos/codeium.sh";
    wtm = "nohup webstorm & disown";
    # build-logs-app = "npm run build && git add . && git commit -m 'update' && git push && connect-contabo-prod sh update_logger.sh";
    ls = "eza --icons=always";
    cd = "z";
  };

   # Define your color variables
  fg = "#d8dee9";
  bg = "#2e3440";
  purple = "#b48ead";
  bg_highlight = "#3b4252";
  blue = "#81a1c1";
  cyan = "#88c0d0";

in
{

  # Allow unfree packages
  #      nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  #  home.packages = with pkgs; [
  #  ];

  # Home Manager is pretty good at managing nixfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'nixfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = nixfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/dprint/dprint.json".text = ''
      {
        "extends": [
          "https://raw.githubusercontent.com/m-pot/lint/refs/heads/master/dprint.json"
        ]
      }
    '';
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

  #  programs.ssh = {
  #   enable = true;
  #   extraConfig = ''
  #     AddKeysToAgent yes
  #     UseKeychain yes
  #   '';
  # };

  services.ssh-agent = {
    enable = true;
    # enableSSHAskPass = true;
    # identities = [ "/home/muiga/.ssh/id_ed25519_gh" ];
  };



  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    shellAliases = myAliases;
    initExtra = ''
      export PATH=$PATH:${pkgs.oh-my-posh}/bin
      eval "$(oh-my-posh init zsh --config /etc/nixos/oh-my-posh/pure.toml)"
      export PATH=$PATH:${pkgs.fzf}/bin
      eval "$(fzf --zsh)"
      # --- setup fzf theme ---
      fg="#CBE0F0"
      bg="#011628"
      bg_highlight="#143652"
      purple="#B388FF"
      blue="#06BCE4"
      cyan="#2CF9ED"

      export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

      # -- Use fd instead of fzf --
      export PATH=$PATH:${pkgs.fd}/bin
      export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

      # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - See the source code (completion.{bash,zsh}) for the details.
      _fzf_compgen_path() {
        fd --hidden --exclude .git . "$1"
      }

      # Use fd to generate the list for directory completion
      _fzf_compgen_dir() {
        fd --type=d --hidden --exclude .git . "$1"
      }
      export PATH=$PATH:${pkgs.fzf-git-sh}/bin
      # source fzf-git.sh

      show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

      export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

      # Advanced customization of fzf options via _fzf_comprun function
      # - The first argument to the function is the name of the command.
      # - You should make sure to pass the rest of the arguments to fzf.
      _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always \{} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo $\{}'"         "$@" ;;
          ssh)          fzf --preview 'dig \{}'                   "$@" ;;
          *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
        esac
      }

      # # thefuck alias
      # eval $(thefuck --alias fk)

      # ---- Zoxide (better cd) ----
      eval "$(zoxide init zsh)"

      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519_gh
      fi

    '';
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";  //
  };


  # Let Home Manager install and manage itself.

  home.stateVersion = "24.05"; # Please read the comment before changing.

}
