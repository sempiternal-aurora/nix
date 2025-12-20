# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
args@{
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    # You will need to generate a hardware configuration with hardware by running
    # > sudo nixos-generate-config
    # and copying the result from /etc/nixos
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto.cachyOverride {
    useLTO = "full";
    mArch = "ZEN4";
  };
  # boot.kernelPackages = pkgs.linuxPackagesFor (
  #   (pkgs.linux_zen.override {
  #     stdenv = pkgs.overrideCC pkgs.llvmPackages_latest.stdenv (
  #       # Tell our C compiler (Clang) to use LLVM bintools--normally GNU
  #       # binutils are used even with Clang as the compiler.
  #       pkgs.llvmPackages_latest.stdenv.cc.override {
  #         bintools = pkgs.llvmPackages_latest.bintools;
  #       }
  #     );
  #     # Tell Linux that we're compiling with Clang and LLVM.
  #     extraMakeFlags = [ "LLVM=1" ];
  #     withRust = true;
  #
  #     # If you'd like to edit your kernel configuration, use
  #     # `structuredExtraConfig`. For example, some options available to us
  #     # when compiling with Clang and linking with LLD:
  #     structuredExtraConfig = {
  #       # Optimisation flags
  #       MZEN4 = lib.kernel.yes;
  #       CC_OPTIMIZE_FOR_PERFORMANCE_O3 = lib.kernel.yes;
  #
  #       # Clang flags
  #       CFI_CLANG = lib.kernel.yes;
  #       LTO_CLANG_FULL = lib.kernel.yes;
  #
  #       # Rust support
  #       RUST = lib.kernel.yes;
  #     };
  #
  #     argsOverride = {
  #       ignoreConfigErrors = true;
  #       # Tell Linux that we're compiling with Clang and LLVM.
  #       extraMakeFlags = [ "LLVM=1" ];
  #
  #       # If you'd like to edit your kernel configuration, use
  #       # `structuredExtraConfig`. For example, some options available to us
  #       # when compiling with Clang and linking with LLD:
  #       structuredExtraConfig = {
  #         # Optimisation flags
  #         MZEN4 = lib.kernel.yes;
  #         CC_OPTIMIZE_FOR_PERFORMANCE_O3 = lib.kernel.yes;
  #
  #         # Clang flags
  #         CFI_CLANG = lib.kernel.yes;
  #         LTO_CLANG_FULL = lib.kernel.yes;
  #         RUST = lib.kernel.yes;
  #
  #         # Zen Interactive tuning
  #         ZEN_INTERACTIVE = lib.kernel.yes;
  #
  #         # FQ-Codel Packet Scheduling
  #         NET_SCH_DEFAULT = lib.kernel.yes;
  #         DEFAULT_FQ_CODEL = lib.kernel.yes;
  #
  #         # Preempt (low-latency)
  #         PREEMPT = lib.mkOverride 90 lib.kernel.yes;
  #         PREEMPT_VOLUNTARY = lib.mkOverride 90 lib.kernel.no;
  #
  #         # Preemptible tree-based hierarchical RCU
  #         TREE_RCU = lib.kernel.yes;
  #         PREEMPT_RCU = lib.kernel.yes;
  #         RCU_EXPERT = lib.kernel.yes;
  #         TREE_SRCU = lib.kernel.yes;
  #         TASKS_RCU_GENERIC = lib.kernel.yes;
  #         TASKS_RCU = lib.kernel.yes;
  #         TASKS_RUDE_RCU = lib.kernel.yes;
  #         TASKS_TRACE_RCU = lib.kernel.yes;
  #         RCU_STALL_COMMON = lib.kernel.yes;
  #         RCU_NEED_SEGCBLIST = lib.kernel.yes;
  #         RCU_FANOUT = lib.kernel.freeform "64";
  #         RCU_FANOUT_LEAF = lib.kernel.freeform "16";
  #         RCU_BOOST = lib.kernel.yes;
  #         RCU_BOOST_DELAY = lib.kernel.option (lib.kernel.freeform "500");
  #         RCU_NOCB_CPU = lib.kernel.yes;
  #         RCU_LAZY = lib.kernel.yes;
  #         RCU_DOUBLE_CHECK_CB_TIME = lib.kernel.yes;
  #
  #         # BFQ I/O scheduler
  #         IOSCHED_BFQ = lib.mkOverride 90 lib.kernel.yes;
  #
  #         # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
  #         FUTEX = lib.kernel.yes;
  #         FUTEX_PI = lib.kernel.yes;
  #
  #         # NT synchronization primitive emulation
  #         NTSYNC = lib.kernel.yes;
  #
  #         # Preemptive Full Tickless Kernel at 1000Hz
  #         HZ = lib.kernel.freeform "1000";
  #         HZ_1000 = lib.kernel.yes;
  #       };
  #     };
  #   }).overrideAttrs
  #     # Work around another NixOS specific issue where builds with WERROR=y
  #     # are stopped by a benign error. See reference 1 below for details.
  #     # Technically, this fix is only necessary with WERROR=y but the issue
  #     # still causes a warning on builds where WERROR is unset.
  #     { env.NIX_CFLAGS_COMPILE = "-Wno-unused-command-line-argument"; }
  # );

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };

  admin-user = {
    enable = true;
    userName = vars.adminUser;
    homeManager = import ./home.nix (args // { userName = vars.adminUser; });
  };

  local-user = {
    enable = true;
    userName = vars.localUser;
    homeManager = import ./home.nix (args // { userName = vars.localUser; });
  };

  networking.hostName = "coimpiutair"; # Define your hostname.

  # Allow unfree licences for some packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "1password-gui"
      "1password-cli"
      "1password"
      "idea"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "zoom"
      "nordvpn"
    ];

  environment.systemPackages = [
    pkgs.framework-tool
  ];

  # nordvpn config
  chaotic.nordvpn.enable = true;
  users.users."${vars.adminUser}".extraGroups = [ "nordvpn" ];
  users.users."${vars.localUser}".extraGroups = [ "nordvpn" ];
  networking.firewall = {
    # checkReversePath = false;
    allowedUDPPorts = [ 1194 ];
    allowedTCPPorts = [ 443 ];
  };

  mine = {
    keyboard = {
      enable = true;
      caps2esc = true;
    };

    greetd = {
      enable = false;
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd \"systemd-cat --identifier=sway sway\"";
    };
    ly.enable = true;
    sway.enable = true;
    audio.enable = true;
    steam.enable = true;
    lutris.enable = true;
    itch.enable = true;
    prism.enable = true;
    media.enable = true;
    tailscale.enable = true;
    globalprotect.enable = true;
    bluetooth.enable = true;
    printing.enable = true;
    brillo.enable = true;
    fprintd.enable = true;
    udisks2.enable = true;
    usbhotspot.enable = true;
    yazi.enable = true;
    uutils.enable = false;
    docs.enable = true;
    openocd.enable = true;
  };

  # 1Password __MUST__ be installed as root
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [
      vars.adminUser
      vars.localUser
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  zramSwap = {
    enable = true;
    priority = 2;
  };
  swapDevices = [
    # {
    #   device = "/var/lib/swapfile";
    #   size = 16 * 1024;
    #   priority = 1;
    # }
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        vars.adminUser
        vars.localUser
      ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true; # Unavailable with flakes

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
