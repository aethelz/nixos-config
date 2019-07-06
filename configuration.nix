{ config, pkgs, options, ... }:

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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super:
    let unstablePinned =
      fetchGit {
        url = "https://github.com/NixOS/nixpkgs-channels";
        rev = "4dd5c93998da55002fdec1c715c680531420381c";
        ref = "nixos-unstable";
      };
    in
    {
      unstable = (import unstablePinned {}).pkgs;
    })

    (import /home/gene/nixos-config/overlay/01-lazydocker.nix)

  ];
  nix.nixPath = options.nix.nixPath.default ++
  [
    "nixpkgs-overlays=/home/gene/nixos-config/overlay/"
  ];

  boot = {
    tmpOnTmpfs = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "usb_storage"
    ];
    kernelPackages = pkgs.linuxPackages_5_1;
    kernelModules = [ "kvm-intel" ];
    resumeDevice = "/dev/nvme0n1p2";
    kernelParams = [
      "resume_offset=83968" # swap file offset
      "i915.enable_fbc=1"
      "i915.fastboot=1"
      ];
    kernel.sysctl = { "vm.swappiness" = 1; };
  };

  networking = {
    hostName = "acer";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  environment.etc.current-nixos-config.source = ./.;
  environment.systemPackages = with pkgs; [
    bat
    unstable.docui
    unstable.moc
    exa
    fd
    feh
    git
    gotop
    htop
    libreoffice
    mpv
    ncdu
    neofetch
    nmap
    nfs-utils
    pass
    pulsemixer
    ranger
    ripgrep
    sshfs
    termite
    lazydocker
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
  virtualisation.docker.enable = true;

  home-manager.users.gene = (import ./gene.nix) pkgs;

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
    bluetooth.enable = false;
    bluetooth.powerOnBoot = false;
    brightnessctl.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    opengl.enable = true;
    pulseaudio.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    tlp.enable = true;
    fstrim.enable = true;
    journald.extraConfig = "SystemMaxUse=50M";
    openvpn.servers = {
      homeVPN = {
        config = '' config /etc/vpn/acer.ovpn '';
        updateResolvConf = true;
      };
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      libinput.enable = true;
      libinput.accelProfile = "flat";
      layout = "us,ru";
      # Change layout on left control
      xkbOptions = "grp:lctrl_toggle";
      # videoDrivers = [ "intel" ];
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
  };

  users.users.gene = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
  };

  system.stateVersion = "19.03";
}
