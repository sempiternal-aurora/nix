{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mine.mathematica;
in {
  options = {
    mine.mathematica.enable = lib.mkEnableOption "Enable Mathematica";
    mine.mathematica.version = lib.mkOption {
      type = lib.types.str;
      default = "13.2.1";
      example = "13.2.1";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.mathematica.override {
        version = cfg.version;
        source = ./source/Mathematica_13.2.1_BNDL_LINUX.sh;
      })
    ];
  };
}
