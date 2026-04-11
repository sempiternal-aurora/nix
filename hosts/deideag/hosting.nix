{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{

  options = {
  };

  config = {
    services.caddy = {
      enable = true;
      virtualHosts."holonet.myria.dev".extraConfig = ''
        respond "Hello, world!"
      '';
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
