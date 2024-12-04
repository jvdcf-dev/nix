# ─────────────────────────╮
# Nix system configuration │
# ─────────────────────────╯
# @jvdcf
# Every setting, package and service applied to the whole system are defined here.

{
  pkgs,
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


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


  # System packages
  # ==========================================================================

  environment.systemPackages = with pkgs; [
    vim
    nh
    git
    intel-ocl # OpenCL support
    kdePackages.xwaylandvideobridge
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
    extraSpecialArgs = { inherit inputs; };
    users = {
      "jvdcf" = import ../home-manager/home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
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
