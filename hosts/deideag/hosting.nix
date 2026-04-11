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

      virtualHosts =
        let
          caddyConfig = url: {
            extraConfig = ''
              root * /var/www/${url}/public_html
              file_server
              php_fastcgi ${config.services.phpfpm.pools.holonet.socket}
            '';
          };
        in
        lib.attrsets.genAttrs [
          "holonet.myria.dev"
          "holonet.auroracod.ing"
        ] caddyConfig;
    };

    services.phpfpm.pools.holonet = {
      user = "php";
      group = "php";
      phpPackage = pkgs.php;
      settings = {
        "pm" = "dynamic";
        "pm.max_children" = 75;
        "pm.start_servers" = 10;
        "pm.min_spare_servers" = 5;
        "pm.max_spare_servers" = 20;
        "pm.max_requests" = 500;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
