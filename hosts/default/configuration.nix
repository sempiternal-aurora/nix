# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

args@{ inputs, config, lib, pkgs, vars, ... }:

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
    boot.kernelPackages = pkgs.linuxPackages_latest;


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
        homeManager = ( import ./home.nix ( args // { userName = vars.adminUser; } ) );
    };

    local-user = {
        enable = true;
        userName = vars.localUser;
        homeManager = ( import ./home.nix ( args // { userName = vars.localUser; } ) );
    };

    networking.hostName = "coimpiutair"; # Define your hostname.

    # Allow unfree licences for some packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "discord"
    ];

    services.fprintd.enable = true;

    hardware.brillo.enable = true;

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

