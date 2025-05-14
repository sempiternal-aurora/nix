{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mine.keyboard;
  # tap-time = "150";
  # hold-time = "150";
in
{
  options.mine.keyboard = {
    enable = lib.mkEnableOption "Enable Keybinding management";
    caps2esc = lib.mkEnableOption "Swap Capslock and Escape Keys, and make holding capslock act like holding control";
  };

  config = lib.mkIf cfg.enable {
    services.interception-tools = {
      enable = true;
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };
    /*
        services.kanata = {
          enable = true;
          keyboards.default.config = ''
              (defsrc
                  ${lib.optionalString cfg.caps2esc "caps"}
                  ${lib.optionalString cfg.caps2esc "esc"}
              )

              (defalias
                  ${lib.optionalString cfg.caps2esc "caps (tap-hold ${tap-time} ${hold-time} esc lctl)"}
              )

              (deflayer base
                  ${lib.optionalString cfg.caps2esc "@caps"}
                  caps
              )
          '';
      };
    */
  };
}
