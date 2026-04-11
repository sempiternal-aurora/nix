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
      group = "www-data";
      virtualHosts =
        let
          caddyConfig = url: {
            extraConfig = ''
              root * /var/www/${url}/public_html
              file_server
              php_fastcgi unix/${config.services.phpfpm.pools.holonet.socket}
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
      group = "www-data";
      phpPackage = pkgs.php;
      settings = {
        "listen.owner" = "php";
        "listen.group" = "www-data";
        "pm" = "dynamic";
        "pm.max_children" = 10;
        "pm.start_servers" = 3;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "pm.max_requests" = 500;
      };
    };

    users = {
      groups."www-data" = { };

      users.php = {
        isSystemUser = true;
        createHome = false;
        group = "www-data";
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
