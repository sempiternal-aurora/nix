{ pkgs, ... }:
{

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "Australia/Canberra";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_AU.UTF-8";

    services.printing.enable = true;
    services.fprintd.enable = true;
    services.usbmuxd.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    hardware.brillo.enable = true;

    programs.dconf.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
        pathsToLink = [ "/share/zsh" ];
        systemPackages = with pkgs; [
            neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
            wget
            lf
            git
            libimobiledevice
        ];
    };

    environment.sessionVariables = {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
    };
}

