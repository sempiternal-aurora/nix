{
  lib,
  config,
  pkgs,
  ...
}: let
  scfg = config.mine.steam;
  lcfg = config.mine.lutris;
  icfg = config.mine.itch;
  pcfg = config.mine.prism;
in {
  options = {
    mine.steam.enable = lib.mkEnableOption "install steam";
    mine.lutris.enable = lib.mkEnableOption "install lutris";
    mine.itch.enable = lib.mkEnableOption "install itch.io";
    mine.prism.enable = lib.mkEnableOption "install prism launcher for minecraft";
  };

  config = {
    environment.systemPackages =
      lib.lists.optional lcfg.enable pkgs.lutris
      ++ lib.lists.optional icfg.enable pkgs.itch
      ++ lib.lists.optional pcfg.enable pkgs.prismlauncher;
    programs.steam.enable = scfg.enable;
  };
}
