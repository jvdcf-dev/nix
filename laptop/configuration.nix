# ─────────────────────────╮
# Nix system configuration │
# ─────────────────────────╯
# @jvdcf
# Every setting, package and service applied to the whole system are defined here.
{
  pkgs,
  pkgs-stable,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix Settings
  # ==========================================================================

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

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
  networking.hostName = "SillyBilly";

  # Asusctl service
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

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

  # Media Codecs and Graphics Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  services.xserver.videoDrivers = [ "i915" ];

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

  # Location: Portugal
  location.latitude = 41.0;
  location.longitude = -8.0;

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
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_level=3"
    "i915.force_probe=7d55" # Alder Lake bug fix
    "vt.global_cursor_default=0"
  ];

  # Latest Linux kernel, instead of the default LTS
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Don't show nix generations on boot (bypass by pressing any key)
  boot.loader.timeout = 0;

  # Power management for laptops
  # ==========================================================================

  services.power-profiles-daemon.enable = false;
  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "quiet";

      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      INTEL_GPU_MIN_FREQ_ON_AC = 800;
      INTEL_GPU_MIN_FREQ_ON_BAT = 800;
      INTEL_GPU_MAX_FREQ_ON_AC = 2200;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1100;
      INTEL_GPU_BOOST_FREQ_ON_AC = 2200;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1100;

      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 75;

      RESTORE_THRESHOLDS_ON_BAT = 1;

      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC = "254";
      DISK_APM_LEVEL_ON_BAT = "254";
      DISK_IOSCHED = "none";
    };
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  # System packages
  # ==========================================================================

  environment.systemPackages = with pkgs; [
    # Kernel
    linux-firmware

    # Utilities
    vim
    nh
    git
    kdePackages.xwaylandvideobridge

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

    # GPU related (see https://www.binarytides.com/check-intel-igpu-details-on-ubuntu/)
    inxi
    pciutils
    toybox
    virtualglLib
    lshw
    intel-gpu-tools
  ];

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

  # Time zone and locale
  # ==========================================================================

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

  # Windowing System
  # ==========================================================================

  # Enable X11
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

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
      "jvdcf" = import ./home.nix;
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

  # ==========================================================================

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
