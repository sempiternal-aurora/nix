{
  lib,
  userName ? "user",
  ...
}: {
  imports = [
    ../../modules/home-manager
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  mine = {
    terminal = {
      newsboat = true;
      spotify-player = true;
      weechat = true;
      trash = true;
      mercurial = true;
      zip = true;
      zsh = true;
      zoxide = true;
      btop = true;
      hyfetch = true;
      eza = true;
      lf = true;
      yazi = true;
      starship = true;
    };
    direnv.enable = true;
    sway = {
      enable = true;
      powercheck = true;
    };
    zoom.enable = true;
    _1password = {
      enable = true;
      kwallet.enable = true;
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
    };
    nvim = {
      enable = true;
      default = true;
    };
    isabelle = {
      enable = true;
      enableNeovimIntegration = true;
    };
    jetbrains = {
      enable = true;
      intellij = true;
    };
    calibre.enable = true;
    digital.enable = true;
    mathematica.enable = true;
    firefox.enable = true;
  };

  # Allow unfree licences for some packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "1password"
      "1password-gui"
      "idea-ultimate"
      "mathematica"
      "zoom-us"
    ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aurora/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
