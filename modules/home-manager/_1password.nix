{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mine._1password;
  kcfg = config.mine._1password.kwallet;
in {
  options = {
    mine._1password.enable = lib.mkEnableOption "Enable 1Password";
    mine._1password.kwallet.enable = lib.mkEnableOption "Enable KDEWallet";
    mine._1password.systemd.enable = lib.mkEnableOption "Enable 1Password Systemd integration";
    mine._1password.systemd.target = lib.mkOption {
      type = lib.types.str;
      default = "graphical-session.target";
      example = "sway-session.target";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf kcfg.enable {
      home.packages = [
        pkgs.kdePackages.kwallet
      ];
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        pinentry = {
          package = pkgs.pinentry-qt;
          program = "pinentry-qt";
        };
      };
    })
    (lib.mkIf cfg.systemd.enable {
      systemd.user.services._1password = {
        Unit = {
          Description = "1Password GUI";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session-pre.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
          ExecReload = "${pkgs.uutils-coreutils-noprefix}/bin/kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          KillMode = "mixed";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };

        Install = {WantedBy = [cfg.systemd.target];};
      };
    })
  ]);
}
