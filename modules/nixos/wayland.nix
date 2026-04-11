{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mine.sway;
in
{
  options = {
    mine.sway.enable = lib.mkEnableOption "sway tiling window manager";
  };
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [ pkgs.swayfx ];
      wlr.enable = true;
    };

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
