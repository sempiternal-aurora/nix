{
  lib,
  config,
  ...
}:
let
  cfg = config.mine.jellyfin;
in
{
  options.mine.jellyfin = {
    enable = lib.mkEnableOption "Enable local jellyfin media server";
    openFirewall = lib.mkEnableOption "Open firewall ports";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = cfg.openFirewall;
    };
  };
}
