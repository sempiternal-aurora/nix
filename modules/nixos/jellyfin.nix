{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mine.jellyfin;
in {
  options.mine.jellyfin.enable = lib.mkEnableOption "Enable local jellyfin media server";

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };
  };
}
