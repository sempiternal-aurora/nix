{ pkgs, config, lib, ... }:
let
    cfg = config.mine.greetd;
in
{
    options.mine.greetd = {
        enable = lib.mkEnableOption "Enable greetd tui greeting service";
        command = lib.mkOption {
            description = "The command greetd runs";
        };
    };

    config = lib.mkIf cfg.enable {
        console = {
            font = "ter-i28b";
            packages = with pkgs; [ terminus_font ];
            keyMap = "us";
        };

        services.greetd = {
            enable = true;
            vt = 1;
            settings.default_session.command = cfg.command;
        };
    };
}
