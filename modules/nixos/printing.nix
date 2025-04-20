{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {mine.printing.enable = lib.mkEnableOption "printing daemon CUPS";};
  config = {
    services.printing = {
      enable = config.mine.printing.enable;
      drivers = [
        pkgs.brlaser
        pkgs.hplip
      ];
    };

    # Enable ipp everywhere
    services.avahi = {
      enable = config.mine.printing.enable;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
