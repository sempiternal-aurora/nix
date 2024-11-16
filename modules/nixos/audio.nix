{ pkgs, ... }:
{
    config = {
        # Enable sound.
        services.pipewire = {
            enable = true;
            pulse.enable = true;
        };
    };
}

