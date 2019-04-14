{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchGit {
        url = "https://github.com/rycee/home-manager";
      }}/nixos"
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos"; # Define your hostname.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    exa
    fd
    git
    gotop
    htop
    ncdu
    neofetch
    ranger
    ripgrep
    silver-searcher
    termite
    tig
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.bash.enableCompletion = true;
  programs.tmux.enable = true;
  home-manager.users.gene = {
    home.file.".config/nvim/init.vim".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/nvim/.config/nvim/init.vim";
    home.file.".local/share/nvim/site/autoload/plug.vim".source = "${builtins.fetchGit {
      url = "https://github.com/junegunn/vim-plug/";
    }}/plug.vim";
    home.file.".config/ranger/rc.conf".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/ranger/.config/ranger/rc.conf";
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.fzf.enable = true;
    programs.neovim.enable = true;
    programs.neovim.vimAlias = true;
    programs.neovim.viAlias = true;
    programs.bash.enable = true;
    programs.bash.sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files";
      PS1 = ''\[\e[0;30m\e[44m\]\u@\h:\w\$\[\e[0m\] '';
    };
    programs.bash.shellAliases = {
      dir = "exa --long --git --all";
    };
    programs.bash.shellOptions = [
    ];
    programs.bash.bashrcExtra = ''
      rg() {
        if [ -z "$RANGER_LEVEL" ]
        then
          ranger
        else
          exit
        fi
      }
      [ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '
      bind '"\e[5~": history-search-backward'
      bind '"\e[6~": history-search-forward'
      '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation.vmware.guest.enable = true;
  virtualisation.vmware.guest.headless = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gene = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/gene";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "18.03"; # Did you read the comment?

}
