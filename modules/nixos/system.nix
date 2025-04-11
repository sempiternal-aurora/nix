{pkgs, ...}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Australia/Canberra";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  services.fprintd.enable = true;
  services.usbmuxd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  hardware.brillo.enable = true;

  programs.dconf.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    pathsToLink = ["/share/zsh"];
    systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      yazi
      git
      libimobiledevice
    ];
  };

  # environment.etc = {
  #   "1password/custom_allowed_browsers" = {
  #     text = ''
  #       zen-bin
  #       zen
  #     '';
  #     mode = "0755";
  #   };
  # };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
