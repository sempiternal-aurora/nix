{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlazer
      pkgs.hplip
    ];
  };

  # Enable ipp everywhere
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
