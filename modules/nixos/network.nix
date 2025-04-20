{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    mine.tailscale.enable = lib.mkEnableOption "install tailscale client";
    mine.globalprotect.enable = lib.mkEnableOption "globalprotect vpn gui";
    mine.bluetooth.enable = lib.mkEnableOption "bluetooth support";
  };
  config = {
    networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.tailscale = {
      enable = config.mine.tailscale.enable;
      useRoutingFeatures = "client";
    };

    # VPN Stuff
    environment.systemPackages =
      lib.lists.mkOptional
      config.mine.globalprotect.enable
      pkgs.globalprotect-openconnect;
    services.globalprotect.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    hardware.bluetooth.enable = config.mine.bluetooth.enable;
    services.blueman.enable = config.mine.bluetooth.enable;
  };
}
