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
            pkgs.lua-language-server
            pkgs.nil
            #pkgs.rust-analyzer
            #pkgs.ltex-ls

            # needed by treesitter
            pkgs.clang
            pkgs.clang-tools

            # needed by telescope
            pkgs.ripgrep
            pkgs.fd
        ];

        xdg.mimeApps = {
            enable = true;
            defaultApplications = {
                "application/json"  = [ "nvim.desktop" ];
                "text/*"            = [ "nvim.desktop" ];
            };
        };

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
