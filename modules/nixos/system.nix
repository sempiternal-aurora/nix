{ pkgs, ... }:
{

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "Australia/Canberra";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_AU.UTF-8";

    services.printing.enable = true;

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
}

