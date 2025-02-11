{
  lib,
  config,
  ...
}: let
  cfg = config.mine.audio;
in {
  options.mine.audio = {
    enable = lib.mkEnableOption "Enable pipewire audio management";
  };

  config = lib.mkIf cfg.enable {
    # Enable sound.
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
