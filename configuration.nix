{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchGit {
        url = "https://github.com/rycee/home-manager";
        rev = "ff602cb906e3dd5d5f89c7c1d0fae65bc67119a0";
        ref = "release-19.03";
      }}/nixos"
    ];

  boot = {
    tmpOnTmpfs = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_5_0;
    resumeDevice = "/dev/nvme0n1p2";
    kernelParams = [
      "resume_offset=83968" # swap file offset
      "i915.enable_fbc=1"
      "i915.fastboot=1"
      ];
    kernel.sysctl = { "vm.swappiness" = 1; };
  };

  networking.hostName = "acer";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [
    bat
    exa
    fd
    feh
    git
    gotop
    htop
    libreoffice
    moc
    mpv
    ncdu
    neofetch
    nmap
    nfs-utils
    pass
    ranger
    sshfs
    termite
    tig
    unzip
    w3m
    wget
    xcalib
    xcape
    xorg.xmodmap
    xorg.xsetroot
    youtube-dl
  ];

  fonts.fonts = with pkgs; [
    terminus_font
  ];

  programs.vim.defaultEditor = true;

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
    home.file.".config/termite/config".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/termite/.config/termite/config";
    home.file.".Xmodmap".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/xmodmap/.Xmodmap";
    home.file.".config/acer.icm".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/color/acer.icm";
    home.file.".config/i3/config".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/i3/.config/i3/config";
    home.file.".inputrc".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/readline/.inputrc";
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs = {
      zathura.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      fzf.defaultCommand = "rg --files";
      neovim.enable = true;
      neovim.vimAlias = true;
      neovim.viAlias = true;
      bash = {
        enable = true;
        shellAliases = {
          dir = "exa --long --git --all";
        };
        shellOptions = [ "autocd" ];
        historyControl = [
          "erasedups"
          "ignoredups"
        ];
        historyIgnore = [ "cd" ];
        bashrcExtra = ''
          export EDITOR="nvim"
          export PS1="\[\e[0;30m\e[44m\]\u@\h:\w\$\[\e[0m\] "
          rg() {
          if [ -z "$RANGER_LEVEL" ]
          then
          ranger
          else
          exit
          fi
          }
          [ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '
        '';
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  hardware = {
    brightnessctl.enable = true;
    opengl.enable = true;
    pulseaudio.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  services.tlp.enable = true;
  services.journald.extraConfig = "SystemMaxUse=50M";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    libinput.enable = true;
    libinput.accelProfile = "flat";
    layout = "us,ru";
    # Change layout on left control
    xkbOptions = "grp:lctrl_toggle";
    videoDrivers = [ "intel" ];
    # deviceSection = ''
    #   Option "TearFree" "true"
    # '';

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager.lightdm.greeters.mini = {
      enable = true;
      user = "gene";
      extraConfig = ''
      [greeter]
      show-password-label = false
      '';
    };

    windowManager = {
      default = "i3";
      i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
        # swap ctrl and caps, apply color profile
        extraSessionCommands = ''
        xmodmap /home/gene/.Xmodmap && xcape -e 'Control_L=Escape'
        xcalib -d :0 /home/gene/.config/acer.icm
        '';
      };
    };
  };

  users.users.gene = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  system.stateVersion = "19.03";

}
