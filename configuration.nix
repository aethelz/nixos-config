{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchGit {
        url = "https://github.com/rycee/home-manager";
        rev = "dff5f07952e61da708dc8b348ea677414e992215";
        ref = "release-19.09";
      }}/nixos"
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super:
    let unstablePinned =
      fetchGit {
        url = "https://github.com/NixOS/nixpkgs-channels";
        rev = "7827d3f4497ed722fedca57fd4d5ca1a65c38256";
        ref = "nixos-unstable";
      };
    in
    {
      unstable = (import unstablePinned {}).pkgs;
    })

    # (import /home/gene/nixos-config/overlay/01-lazydocker.nix)
    # (import /home/gene/nixos-config/overlay/02-docui.nix)

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
    kernelPackages = pkgs.linuxPackages_latest;
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
    docui
    moc
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
  virtualisation.virtualbox.host.enable = true;

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
    enableRedistributableFirmware = true;
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
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
      "vboxusers"
    ];
  };

  system.stateVersion = "19.03";
}
