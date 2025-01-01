{
    lib,
    config,
    pkgs,
    ...
}:

let
    cfg = config.mine.isabelle;
in
{
    options = {
        mine.isabelle.enable = lib.mkEnableOption "Install Isabelle";
	    mine.isabelle.enableNeovimIntegration = lib.mkEnableOption "Setup Isabelle neovim extension";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.isabelle ];

        home.file.".isabelle/isabelle-lsp" = {
            enable = cfg.enableNeovimIntegration;
            recursive = true;
            source = pkgs.fetchhg {
                url = "https://isabelle-dev.sketis.net/source/isabelle/";
                rev = "92768949a923";
            };
        };
 
    };
}
 
