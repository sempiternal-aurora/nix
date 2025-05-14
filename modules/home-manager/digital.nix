{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mine.digital;
in
{
  options = {
    mine.digital.enable = lib.mkEnableOption "Enable Digital";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.digital
    ];
    home.sessionVariables = {
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";
    };
  };
}
