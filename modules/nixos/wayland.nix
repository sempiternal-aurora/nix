{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {mine.sway.enable = lib.mkEnableOption "sway tiling window manager";};
  config = {
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk];
      configPackages = [pkgs.swayfx];
      wlr.enable = true;
    };

    programs.sway = {
      enable = config.mine.sway.enable;
      package = pkgs.swayfx;
    };
  };
}
