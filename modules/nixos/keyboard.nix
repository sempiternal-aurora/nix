{ lib, config, ... }:
let
    cfg = config.mine.keyboard;
    tap-time = "50";
    hold-time = "100";
in
{
    options.mine.keyboard = {
        enable = lib.mkEnableOption "Enable Keybinding management";
        caps2esc = lib.mkEnableOption "Swap Capslock and Escape Keys, and make holding capslock act like holding control";
    };

    config = lib.mkIf cfg.enable {
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

    };

}
