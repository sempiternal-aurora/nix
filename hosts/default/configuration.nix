# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, vars, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        # You will need to generate a hardware configuration with hardware by running
        # > sudo nixos-generate-config
        # and copying the result from /etc/nixos
        ./hardware-configuration.nix
        ../../modules/nixos
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

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    admin-user = {
        enable = true;
        userName = vars.adminUser;
    }

    networking.hostName = "coimpiutair"; # Define your hostname.
    networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Set your time zone.
    time.timeZone = "Australia/Canberra";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "ter-i28b";
        packages = with pkgs; [ terminus_font ];
        keyMap = "us";
    };

    # Allow unfree licences for some packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "discord"
    ];

    services.greetd = {
        enable = true;
        vt = 1;
        settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd \"systemd-cat --identifier=sway sway\"";
    };

    programs.sway = {
        enable = true;
        extraPackages = with pkgs; [ swaylock-effects swayidle kitty tofi playerctl
                                     grim slurp wl-clipboard-rs swappy copyq 
			                    	 blueman networkmanagerapplet ];
        package = pkgs.swayfx;
    };

    programs.zsh.enable = true;
    programs.waybar.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.blueman.enable = true;

    hardware.brillo.enable = true;

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Hasklig" ]; })
    ];

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
        mutableUsers = true;
        users = {
            aurora = {
                isNormalUser = true;
                extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
                packages = with pkgs; [
                    firefox
                    discord
	                starship
	                hyfetch
	                eza
	                vivid
                ];
                shell = pkgs.zsh;
            };
            myria = {
                isNormalUser = true;
                extraGroups = [ "video" ]; # Enable ‘sudo’ for the user.
                packages = with pkgs; [
                    firefox
                    discord
	                starship
	                hyfetch
	                eza
	                vivid
                ];
                shell = pkgs.zsh;
            };
        };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        greetd.tuigreet
        lf
        git
        gcc
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    system.copySystemConfiguration = true;

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

