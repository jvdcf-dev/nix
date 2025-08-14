{
  pkgs,
  pkgs-stable,
  inputs,
  lib,
  ...
}:
{
  # Nix Settings
  # ==========================================================================

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix Store Optimizations
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "02:00" ]; # Every night at 2h

  # Hardware related services
  # ==========================================================================

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # CUPS: Printing
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Firmware updates
  services.fwupd.enable = true;

  # SSD settings
  environment.etc."lvm/lvm.conf".text = lib.mkForce ''
    devices {
      issue_discards = 1
    }
    allocations {
      thin_pool_discards = 1
    }
  '';
  services.fstrim.enable = true;

  # Boot and kernel
  # ==========================================================================

  # Bootloader with Secure Boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.consoleMode = "max"; # Set resolution of Plymouth
  boot.kernelParams = lib.mkDefault [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_level=3"
    "vt.global_cursor_default=0"
  ];

  # Don't show nix generations on boot (bypass by pressing any key)
  boot.loader.timeout = 0;

  # System packages and services
  # ==========================================================================

  environment.systemPackages = lib.mkDefault (
    with pkgs;
    [
      # Kernel
      linux-firmware

      # Utilities
      vim
      nh
      git
      kdePackages.xwaylandvideobridge
      wayland-utils

      # Smart card utilities
      pcsclite
      ccid
      opensc

      # Maintenance tools
      smartmontools
      htop
      iotop-c
      sbctl
      clight-gui
    ]
  );

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    texlivePackages.nunito
    texlivePackages.comfortaa
  ];

  # Shells
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    zsh
    dash
  ];

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "jvdcf" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;

  # Steam and "system" games
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.anime-game-launcher.enable = true;

  # KDE Connect
  programs.kdeconnect.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Smart card
  services.pcscd.enable = true;

  # ADB for connection with Android devices
  programs.adb.enable = true;

  # Streaming with Moonlight
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Locale
  # ==========================================================================

  # Location: Portugal
  location.latitude = 41.0;
  location.longitude = -8.0;

  # Time zone
  time.timeZone = "Europe/Lisbon";

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Windowing System
  # ==========================================================================

  # Enable X11
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # Users
  # ==========================================================================

  users.defaultUserShell = pkgs.dash;
  users.users.root.shell = pkgs.dash;

  # My account
  users.users.jvdcf = {
    isNormalUser = true;
    description = "João Vítor Ferreira";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "vboxusers"
    ];
    useDefaultShell = true;
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-stable;
    };
    users = {
      "jvdcf" = import ../home-modules/home.nix;
    };
    useUserPackages = true;
    useGlobalPkgs = true; # E.g. enable unfree packages
    backupFileExtension = "backup";
  };

  # Automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jvdcf";

  # Hot patch for race condition between autologin and SDDM
  systemd.services.display-manager.wants = [
    "systemd-user-sessions.service"
    "multi-user.target"
    "network-online.target"
  ];
  systemd.services.display-manager.after = [
    "systemd-user-sessions.service"
    "multi-user.target"
    "network-online.target"
  ];

  # System Theming
  # ==========================================================================

  stylix = {
    enable = true;
    targets.plymouth.enable = false;
    image = ../home-modules/background.jpg;
    polarity = "dark";
    base16Scheme = {
      # Catppuccin Frappe Theme
      base00 = "303446"; # base
      base01 = "292c3c"; # mantle
      base02 = "414559"; # surface0
      base03 = "51576d"; # surface1
      base04 = "626880"; # surface2
      base05 = "c6d0f5"; # text
      base06 = "f2d5cf"; # rosewater
      base07 = "babbf1"; # lavender
      base08 = "e78284"; # red
      base09 = "ef9f76"; # peach
      base0A = "e5c890"; # yellow
      base0B = "a6d189"; # green
      base0C = "81c8be"; # teal
      base0D = "8caaee"; # blue
      base0E = "ca9ee6"; # mauve
      base0F = "eebebe"; # flamingo
    };
  };

  # Other hot patches
  # ==========================================================================

  # Wayland Electron Apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Nautilus trash permissions
  services.gvfs.enable = true;

  # Make OpenCL detectable by applications
  environment.variables.OCL_ICD_VENDORS = "${pkgs.intel-ocl}/etc/OpenCL/vendors/intel.icd";

  # Zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Allows the power button to be mapped into any action, instead of shutting
  # down the system
  services.logind.powerKey = "ignore";
}
