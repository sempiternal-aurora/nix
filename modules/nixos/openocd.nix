{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.openocd;
in {
  options = {
    mine.openocd = {
      enable = lib.mkEnableOption "Enable OpenOCD";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.openocd
    ];
  };
}
