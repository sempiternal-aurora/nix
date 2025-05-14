{
  lib,
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
let
  cfg = config.admin-user;
in
{
  options = {
    admin-user.enable = lib.mkEnableOption "enable user module";
    admin-user.userName = lib.mkOption {
      default = "adminuser";
      description = "priviledged user's name";
    };
    #admin-user.sshKey = lib.mkOption {
    #    description = "your users ssh key";
    #};
    admin-user.homeManager = lib.mkOption {
      description = "primary user's name";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "super user";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "uinput"
      ];
      shell = pkgs.fish;
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

    programs.fish.enable = true;
  };
}
