{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mine.greetd;
  lcfg = config.mine.ly;
in
{
  options.mine.greetd = {
    enable = lib.mkEnableOption "Enable greetd tui greeting service";
    command = lib.mkOption {
      description = "The command greetd runs";
    };
  };
  options.mine.ly = {
    enable = lib.mkEnableOption "Enable ly display manager service";
  };

  config = {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i28b.psf.gz";
      packages = [ pkgs.terminus_font ];
      keyMap = "us";
    };

    services.greetd = {
      enable = cfg.enable;
      settings.default_session.command = cfg.command;
    };
    services.displayManager.ly = {
      enable = lcfg.enable;
      settings = lib.mkDefault {
        brightness_down_cmd = "${pkgs.brillo}/bin/brillo -q -U 5";
        brightness_up_cmd = "${pkgs.brillo}/bin/brillo -q -A 5";
        brightness_down_key = "F7";
        brightness_up_key = "F8";
        clock = "%c";
        default_input = "login";
        tty = 1;
      };
    };
  };
}
