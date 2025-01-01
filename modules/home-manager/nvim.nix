{
    lib,
    config,
    pkgs,
    ...
}:

let
    cfg = config.mine.nvim;
in
{
    options = {
        mine.nvim.enable = lib.mkEnableOption "enable neovim";
        mine.nvim.default = lib.mkEnableOption "set nvim as the default editor";
    };

    config = lib.mkIf cfg.enable {
        # Needed for LSPs to function
        #mine.dev = {
        #    beam = {
        #        enable = true;
        #    };
        #    js = true;
        #};

        home.packages = [
            #pkgs.lua-language-server
            #pkgs.rust-analyzer
            #pkgs.ltex-ls

            # needed by treesitter
            pkgs.clang
            pkgs.clang-tools
        ];

        programs.neovim = {
            enable = true;
            defaultEditor = cfg.default;
            vimAlias = true;
        };

        xdg.configFile."nvim" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/home-manager/nvim-conf";
            recursive = true;
        };
    };
}
