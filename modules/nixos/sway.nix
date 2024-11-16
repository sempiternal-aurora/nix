{ pkgs, ... }:
{
    
    programs.sway = {
        enable = true;
        extraPackages = with pkgs; [ swaylock-effects swayidle tofi playerctl
                                     grim slurp wl-clipboard-rs swappy copyq 
			                    	 blueman networkmanagerapplet ];
        package = pkgs.swayfx;
        xwayland.enable = true;
        wrapperFeatures = {
            base = true;
            gtk = true;
        };
        extraSessionCommands = ''
            # Firefox:
            export MOX_ENABLE_WAYLAND=1
            # SDL:
            export SDL_VIDEODRIVER=wayland
            # QT (needs qt5.qtwayland in systemPackages):
            export QT_QPA_PLATFORM=wayland-egl
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            # Fix for some Java AWT applications (e.g. Android Studio),
            # use this if they aren't displayed properly:
            export _JAVA_AWT_WM_NONREPARENTING=1
            '';
    };
}
