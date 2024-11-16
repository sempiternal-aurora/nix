{ lib, config, pkgs, inputs, ... }:
let
    modifier = "Mod4";
    cfg = config.mine.sway;
in
{
    options = {
        mine.sway = lib.mkEnableOption "enable sway module";
    };
    
    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            tofi
        ];
        
        programs.kitty = {
            enable = true;
            font = {
                name = "HasklugNerdFontMono";
                size = 16;
            };
            settings = {
                disable_ligatures = "cursor";
                background_opacity = 0.9;
            };
            keybindings = {
                "kitty_mod+r" = "no-op";
            };
            shellIntegration.enableZshIntegration = true;
            themeFile = "Dracula";
        };

        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.posy-cursors;
            name = "Posy_Cursor_Black";
            size = 22;
        };

        wayland.windowManager.sway = {
            enable = true;
            package = pkgs.swayfx;
            config = {
                modifier = modifier;
                terminal = "${pkgs.kitty}/bin/kitty";
                menu = "tofi-drun | xargs swaymsg exec --";
                gaps = {
                    inner = 20;
                    outer = 5;
                };
                floating = {
                    border = 2;
                    titlebar = false;
                };
                window = {
                    border = 2;
                    titlebar = false;
                };
                output = {
                    "*".bg = "~/Pictures/Wallpapers/wallpaper fill";
                    eDP-1 = {
                        scale = 1;
                        resolution = "2256x1504";
                        position = "0,0";
                    };
                };
                input."type:touchpad" = {
                    dwt = "enabled";
                    tap = "enabled";
                    natural_scroll = "enabled";
                    scroll_factor = 1;
                }
            };
        };
    };
}

