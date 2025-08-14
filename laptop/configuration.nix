# ─────────────────────────╮
# Nix system configuration │
# ─────────────────────────╯
# @jvdcf
# Every setting, package and service applied to the whole system are defined here.
{
  pkgs,
  ...
}:
{
  imports = [
    ../system-modules
    ./hardware-configuration.nix
  ];

  # Hardware related services
  # ==========================================================================

  # Enable networking
  networking.hostName = "SillyBilly";

  # Asusctl service
  services.asusd = {
    enable = true;
    enableUserService = true;
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

  # Boot and kernel
  # ==========================================================================

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

      # GPU related (see https://www.binarytides.com/check-intel-igpu-details-on-ubuntu/)
      inxi
      pciutils
      toybox
      virtualglLib
      lshw
      intel-gpu-tools
    ];

  # ==========================================================================

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
