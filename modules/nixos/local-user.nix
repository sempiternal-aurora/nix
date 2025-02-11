{
  lib,
  config,
  pkgs,
  inputs,
  vars,
  ...
}: let
  cfg = config.local-user;
in {
  options = {
    local-user.enable = lib.mkEnableOption "enable user module";
    local-user.userName = lib.mkOption {
      default = "localuser";
      description = "normal user's name";
    };
    #local-user.sshKey = lib.mkOption {
    #  description = "your users ssh key";
    #};
    local-user.homeManager = lib.mkOption {
      description = "primary user's name";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "main user";
      extraGroups = [
        "networkmanager"
        "video"
      ];
      shell = pkgs.zsh;
      #openssh.authorizedKeys.keys = [ cfg.sshKey ];
    };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
        vars = vars;
      };
      backupFileExtension = "hm-bak";
      users.${cfg.userName} = cfg.homeManager;
    };

    programs.zsh.enable = true;
  };
}
