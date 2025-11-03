{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mine.mathematica;
in
{
  options = {
    mine.mathematica.enable = lib.mkEnableOption "Enable Mathematica";
    mine.mathematica.version = lib.mkOption {
      type = lib.types.str;
      default = "14.3.0";
      example = "14.3.0";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.mathematica.override {
        version = cfg.version;
      })
    ];
  };
}
