{pkgs, ...}: {
  config = {
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk];
      configPackages = [pkgs.swayfx];
      wlr.enable = true;
    };

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
