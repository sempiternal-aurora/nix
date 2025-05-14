{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mine.docs;
in
{
  options = {
    mine.docs = {
      enable = lib.mkEnableOption "man pages";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.man-pages
      pkgs.man-pages-posix
    ];
    documentation = {
      enable = true;
      doc.enable = true;
      man.enable = true;
      dev.enable = true;
      info.enable = true;
      nixos.enable = true;
    };
  };
}
