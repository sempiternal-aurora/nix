{ pkgs, ... }:
{
    config = {
        console = {
            font = "ter-i28b";
            packages = with pkgs; [ terminus_font ];
            keyMap = "us";
        };

        services.greetd = {
            enable = true;
            vt = 1;
            settings.default_session.command = 
                "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd \"systemd-cat --identifier=sway sway\"";
        };
    };
}
