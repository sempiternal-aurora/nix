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
        source = pkgs.requireFile {
          name = "Mathematica_${cfg.version}_BNDL_LINUX.sh";
          sha256 = "070ybhgskk3fw8c6fgqs4lq9252ds6585cqdd5as94hj55vjibmq";
          message = ''
            Your override for Mathematica includes a different src for the installer,
            and it is missing.
          '';
          hashMode = "recursive";
        };
      })
    ];
  };
}
