{
  lib,
  config,
  ...
}:
let
  cfg = config.mine.podman;
in
{
  options.mine.podman = {
    enable = lib.mkEnableOption "Enable podman for rootless containers";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
