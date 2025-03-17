{config, ...}: {
  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = "main";
    includes = [
      {
        path = "${config.xdg.configHome}/git/gitlab.conf";
        condition = "hasconfig:remote.*.url:git@gitlab.cecs.anu.edu.au:*/**";
      }
      {
        path = "${config.xdg.configHome}/git/github.conf";
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
      }
      {
        path = "${config.xdg.configHome}/git/gitlab.conf";
        condition = "hasconfig:remote.*.url:https://*:*@gitlab.cecs.anu.edu.au/**";
      }
    ];
    maintenance.enable = true;
  };

  xdg.configFile = {
    "git/gitlab.conf" = {
      enable = true;
      text = ''
        [user]
            name = Myria Sarvay
            email = u7644255@anu.edu.au
      '';
    };
    "git/github.conf" = {
      enable = true;
      text = ''
        [user]
            name = "sempiternal-aurora"
            email = "78790545+sempiternal-aurora@users.noreply.github.com"
      '';
    };
  };
}
