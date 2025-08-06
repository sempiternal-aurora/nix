{
  lib,
  config,
  ...
}:
let
  cfg = config.mine.media;
in
{
  options.mine.media = {
    enable = lib.mkEnableOption "Enable media module";
    jellyfin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable local jellyfin media server";
    };
    qbittorrent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable local qbittorrent media server";
    };
    openFirewall = lib.mkEnableOption "Open firewall ports";
  };

  config = lib.mkIf cfg.enable {
    users.groups.media = {
      gid = 759;
    };

    services.qbittorrent = {
      enable = cfg.qbittorrent;
      group = "media";
      openFirewall = cfg.openFirewall;
    };

    services.jellyfin = {
      enable = cfg.jellyfin;
      group = "media";
      openFirewall = cfg.openFirewall;
    };
  };
}
