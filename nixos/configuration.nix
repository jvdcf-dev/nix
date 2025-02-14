# ─────────────────────────╮
# Nix system configuration │
# ─────────────────────────╯
# @jvdcf
# Every setting, package and service applied to the whole system are defined here.
{
  pkgs,
  pkgs-stable,
  pipewire-screenaudio,
  inputs,
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
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # SSD settings
  services.fstrim.enable = true;

  # Boot and kernel
  # ==========================================================================

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
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
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 60;

      RESTORE_THRESHOLDS_ON_BAT = 1;
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
    htop
    vim
    nh
    git
    intel-ocl # OpenCL support
    kdePackages.xwaylandvideobridge

    # Smart card utilities
    pcsclite
    ccid
    opensc
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    texlivePackages.nunito
    texlivePackages.comfortaa
  ];

  # Zsh shell
  programs.zsh.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # KDE Connect
  programs.kdeconnect.enable = true;

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jvdcf" ];

  # Tailscale VPN
  services.tailscale.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Smart card
  services.pcscd.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Users
  # ==========================================================================

  # My account
  users.users.jvdcf = {
    isNormalUser = true;
    description = "João Vítor Ferreira";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-stable;
      inherit pipewire-screenaudio;
    };
    users = {
      "jvdcf" = import ../home-manager/home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
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

  # Theming
  # ==========================================================================

  stylix = {
    enable = true;
    targets.plymouth.enable = false;
    image = ../modules/background.jpg;
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

  # ==========================================================================

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
