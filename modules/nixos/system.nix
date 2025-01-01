{ pkgs, ... }:
{

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "Australia/Canberra";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_AU.UTF-8";

    services.printing.enable = true;
    services.fprintd.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    hardware.brillo.enable = true;

    programs.dconf.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
        systemPackages = with pkgs; [
            neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
            wget
            lf
            git
            gcc
            wgnord
        ];

        pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    };
}

