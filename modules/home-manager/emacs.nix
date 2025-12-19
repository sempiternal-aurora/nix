{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.mine.emacs;
in
{
  options = {
    mine.emacs = {
      enable = lib.mkEnableOption "enable emacs";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = ./source/.doom.d;
    };
  };
}
