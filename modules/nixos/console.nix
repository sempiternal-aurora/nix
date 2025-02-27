{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mine.greetd;
  lcfg = config.mine.ly;
in {
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
      font = "ter-i28b";
      packages = with pkgs; [terminus_font];
      keyMap = "us";
    };

    services.greetd = lib.mkIf cfg.enable {
      enable = true;
      vt = 1;
      settings.default_session.command = cfg.command;
    };
    services.displayManager.ly.enable = lcfg.enable;
  };
}
