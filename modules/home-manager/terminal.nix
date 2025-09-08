{
  lib,
  config,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.mine.terminal;
in
{
  options = {
    mine.terminal.newsboat = lib.mkEnableOption "newsboat: rss aggregation engine";
    mine.terminal.spotify-player = lib.mkEnableOption "spotify-player: cmd-line spotify client";
    mine.terminal.weechat = lib.mkEnableOption "weechat: irc terminal client";
    mine.terminal.trash = lib.mkEnableOption "trash-cli: delete items with ways of recovering them";
    mine.terminal.mercurial = lib.mkEnableOption "mercurial: alternative version control software";
    mine.terminal.zip = lib.mkEnableOption "zip: exactly as it says on the tin";
    mine.terminal.zsh = lib.mkEnableOption "zsh: shell";
    mine.terminal.fish = lib.mkEnableOption "fish: shell";
    mine.terminal.zoxide = lib.mkEnableOption "zoxide: advanced cd alternative";
    mine.terminal.btop = lib.mkEnableOption "btop: hardware monitor";
    mine.terminal.hyfetch = lib.mkEnableOption "hyfetch: pretty hardware info stuff";
    mine.terminal.eza = lib.mkEnableOption "eza: rust utility to list files, like ls";
    mine.terminal.lf = lib.mkEnableOption "lf: hardware file manager";
    mine.terminal.yazi = lib.mkEnableOption "yazi: rust hardware file manager";
    mine.terminal.starship = lib.mkEnableOption "starship: terminal prompt string generator";
    mine.terminal.yt-dlp = lib.mkEnableOption "yt-dlp: cmd-line youtube video downloader";
    mine.terminal.comma = lib.mkEnableOption "comma: program that pulls in other programs not installed via nix";
    mine.direnv.enable = lib.mkEnableOption "install direnv for reproducible development environments";
  };
  config = {
    home.packages = [
      pkgs.lolcat
    ]
    ++ lib.lists.optionals cfg.zip [
      pkgs.zip
      pkgs.unzip
      pkgs.devenv
    ]
    ++ lib.lists.optional cfg.weechat pkgs.weechat
    ++ lib.lists.optional cfg.trash pkgs.trash-cli
    ++ lib.lists.optional cfg.mercurial pkgs.mercurial
    ++ lib.lists.optional cfg.yt-dlp pkgs.yt-dlp
    ++ lib.lists.optional cfg.comma pkgs.comma;

    programs.direnv = {
      enable = config.mine.direnv.enable;
      nix-direnv.enable = true;
    };

    programs.newsboat = {
      enable = cfg.newsboat;
      autoReload = true;
      urls = [
        { url = "https://discourse.nixos.org/t/breaking-changes-announcement-for-unstable/17574.rss"; }
        { url = "https://archlinux.org/feeds/news/"; }
        { url = "https://www.kernel.org/feeds/kdist.xml"; }
        { url = "https://www.sandraandwoo.com/feed"; }
        { url = "https://www.theshovel.com.au/rss"; }
        { url = "https://foxes-in-love.tumblr.com/rss"; }
        { url = "https://another-piece-of-candy.thecomicseries.com/rss"; }
        { url = "https://trick.pika.page/posts_feed"; }
        { url = "https://xkcd.com/atom.xml"; }
        { url = "https://www.imfineimfine.com/feed"; }
        { url = "https://ntietz.com/atom.xml"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCo0-VCHchPIG3JtJlIQnFew"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC0e3QhIYukixgh5VVpKHH9Q"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCePQNin7n0WbY9tEts6oGnw"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClt01z1wHHT7c5lKcU8pxRQ"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCpa-Zb0ZcQjTCPP1Dx_1M8Q"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCFQMnBA3CS502aghlcr0_aw"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC3XTzVzaHQEd30rQbuvCtTQ"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCmtyQOKKmrMVaKuRXz02jbQ"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCICVWhQj3-pqLt45Ww32ARg"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCFhXFikryT4aFcLkLw2LBLA"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfPUcG3oCmXEYgdFuwlFh8w"; }
        { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCqoZ40XymtdcOp2YOoMw9uw"; }
      ];
    };

    programs.spotify-player.enable = cfg.spotify-player;

    programs.fish = {
      enable = cfg.fish;
      functions = {
        fish_greeting = ''
          if test "$TERM" = 'linux'
            hyfetch -m 8bit
          else
            hyfetch
          end
        '';
      };
      plugins = [
        {
          name = "dracula";
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "fish";
            rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
            hash = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
          };
        }
      ];
      shellAliases = {
        pls = "sudo";
        bocsa = "kitten ssh -i ~/.ssh/ssh-key-2023-07-18.key opc@holonet.myria.dev";
        nix-rebuild = "nixos-rebuild switch --flake ~/nix#${vars.configuration} --sudo";
      };
    };

    programs.zsh = {
      enable = cfg.zsh;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      defaultKeymap = "viins";
      history = {
        append = true;
        save = 100000;
        size = 100000;
        share = true;
      };

      shellAliases = {
        pls = "sudo";
        bocsa = "kitten ssh -i ~/.ssh/ssh-key-2023-07-18.key opc@holonet.myria.dev";
        nix-rebuild = "sudo nixos-rebuild switch --flake ~/nix#coimpiutair";
      };
      initContent = ''
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }

        # history substring search
        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search


        key[Home]="''${terminfo[khome]}"
        key[End]="''${terminfo[kend]}"
        key[Insert]="''${terminfo[kich1]}"
        key[Backspace]="''${terminfo[kbs]}"
        key[Delete]="''${terminfo[kdch1]}"
        key[Up]="''${terminfo[kcuu1]}"
        key[Down]="''${terminfo[kcud1]}"
        key[Left]="''${terminfo[kcub1]}"
        key[Right]="''${terminfo[kcuf1]}"
        key[PageUp]="''${terminfo[kpp]}"
        key[PageDown]="''${terminfo[knp]}"
        key[Shift-Tab]="''${terminfo[kcbt]}"
        key[h]="h"
        key[j]="j"
        key[k]="k"
        key[l]="l"

        # setup key accordingly
        [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"       beginning-of-line
        [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"        end-of-line
        [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"     overwrite-mode
        [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}"  backward-delete-char
        [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"     delete-char
        [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         up-line-or-beginning-search
        [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       down-line-or-beginning-search
        [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"       backward-char
        [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"      forward-char
        [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"     beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"   end-of-buffer-or-history
        [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}"  reverse-menu-complete

        # vicmd key setup
        [[ -n "''${key[Home]}"      ]] && bindkey -M vicmd -- "''${key[Home]}"       beginning-of-line
        [[ -n "''${key[End]}"       ]] && bindkey -M vicmd -- "''${key[End]}"        end-of-line
        [[ -n "''${key[Insert]}"    ]] && bindkey -M vicmd -- "''${key[Insert]}"     overwrite-mode
        [[ -n "''${key[Backspace]}" ]] && bindkey -M vicmd -- "''${key[Backspace]}"  backward-delete-char
        [[ -n "''${key[Delete]}"    ]] && bindkey -M vicmd -- "''${key[Delete]}"     delete-char
        [[ -n "''${key[Up]}"        ]] && bindkey -M vicmd -- "''${key[Up]}"         up-line-or-beginning-search
        [[ -n "''${key[Down]}"      ]] && bindkey -M vicmd -- "''${key[Down]}"       down-line-or-beginning-search
        [[ -n "''${key[Left]}"      ]] && bindkey -M vicmd -- "''${key[Left]}"       backward-char
        [[ -n "''${key[Right]}"     ]] && bindkey -M vicmd -- "''${key[Right]}"      forward-char
        [[ -n "''${key[k]}"         ]] && bindkey -M vicmd -- "''${key[k]}"          up-line-or-beginning-search
        [[ -n "''${key[j]}"         ]] && bindkey -M vicmd -- "''${key[j]}"          down-line-or-beginning-search
        [[ -n "''${key[h]}"         ]] && bindkey -M vicmd -- "''${key[h]}"          backward-char
        [[ -n "''${key[l]}"         ]] && bindkey -M vicmd -- "''${key[l]}"          forward-char
        [[ -n "''${key[PageUp]}"    ]] && bindkey -M vicmd -- "''${key[PageUp]}"     beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}"  ]] && bindkey -M vicmd -- "''${key[PageDown]}"   end-of-buffer-or-history
        [[ -n "''${key[Shift-Tab]}" ]] && bindkey -M vicmd -- "''${key[Shift-Tab]}"  reverse-menu-complete

        unsetopt beep
        if [ "$COLUMNS" -lt "105" ]; then
          echo "\n"
        elif [ "$TERM" = 'linux' ]; then
          hyfetch -m 8bit
        else
          hyfetch
        fi
        if [ "$TERM" = 'linux' ] || [ "$TERM" = 'dumb' ]; then
          PS1='%b%F{grey}[%B%F{green}%n%b%f@%F{magenta}%m %B%F{blue}%~%b%F{grey}]%(#.#.$) '
          RPS1='%B%F{cyan}%D{%d/%m/%y %H:%M}%f%b'
        else
          eval "$(${pkgs.starship}/bin/starship init zsh)"
        fi
      '';
    };

    programs.zoxide = {
      enable = cfg.zoxide;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.btop = {
      enable = cfg.btop;
      settings = {
        color_theme = "dracula";
        proc_per_core = true;
        theme_background = false;
        vim_keys = true;
        proc_sorting = "cpu lazy";
        proc_gradient = false;
      };
    };

    programs.starship = {
      enable = cfg.starship;
      enableZshIntegration = false;
      settings = {
        format = lib.concatStrings [
          "[](#9A348E)"
          "$os"
          "$username"
          "[](bg:#DA627D fg:#9A348E)"
          "$directory"
          "[](fg:#DA627D bg:#FCA17D)"
          "$git_branch"
          "$git_status"
          "[](fg:#FCA17D bg:#86BBD8)"
          "$c"
          "$elixir"
          "$elm"
          "$golang"
          "$gradle"
          "$haskell"
          "$java"
          "$julia"
          "$nodejs"
          "$nim"
          "$rust"
          "$scala"
          "[](fg:#86BBD8 bg:#06969A)"
          "$nix_shell"
          "$direnv"
          "[](fg:#06969A bg:#33658A)"
          "$time"
          "[ ](fg:#33658A)"
        ];
        username = {
          show_always = true;
          style_user = "bg:#9A348E";
          style_root = "bg:#9A348E";
          format = "[$user ]($style)";
          disabled = false;
        };
        os = {
          style = "bg:#9A348E";
          disabled = false;
        };

        directory = {
          style = "bg:#DA627D";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙";
            "Downloads" = "";
            "Music" = "";
            "Pictures" = "";
          };
        };

        nix_shell = {
          symbol = "󱄅";
          style = "bg:#06969A";
          impure_msg = "impure";
          pure_msg = "pure";
          format = "[ $symbol $state ]($style)";
        };

        c = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        elixir = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        elm = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        git_branch = {
          symbol = "";
          style = "bg:#FCA17D";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:#FCA17D";
          format = "[$all_status$ahead_behind ]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        gradle = {
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        haskell = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        java = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        julia = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        nodejs = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        nim = {
          symbol = "󰆥";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
          disabled = true;
        };

        rust = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        scala = {
          symbol = " ";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A";
          format = "[ ♥ $time ]($style)";
        };
      };
    };

    programs.yazi = {
      enable = cfg.yazi;
      flavors = {
        dracula = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "yazi";
          rev = "99b60fd76df4cce2778c7e6c611bfd733cf73866";
          hash = "sha256-dFhBT9s/54jDP6ZpRkakbS5khUesk0xEtv+xtPrqHVo=";
        };
      };
      settings = {
        mgr = {
          ratio = [
            1
            4
            3
          ];
          sort_by = "natural";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = true;
          linemode = "size";
          show_hidden = false;
          show_symlink = true;
        };
        preview = {
          wrap = "yes";
          tab-size = 4;
          image-filter = "lanczos3";
        };
        open = {
          play = [
            {
              run = "vlc \"$@\"";
              orphan = true;
              for = "unix";
            }
          ];
        };
      };
      theme = {
        flavor = {
          dark = "dracula";
        };
      };
    };

    programs.lf = {
      enable = cfg.lf;
      settings = {
        ratios = [
          1
          2
          3
        ];
        scrolloff = 10;
        shell = "zsh";
        shellopts = "-eu";
        ifs = "\\n";
        cleaner = "${pkgs.ctpv}/bin/ctpvclear";
        drawbox = true;
        ignorecase = true;
        icons = true;
        info = "size";
      };
      keybindings = {
        "<enter>" = "shell";
        x = "$$f";
        X = "!$f";
        o = "&mimeopen $f";
        O = "$mimeopen --ask $f";
        md = "mkdir";
        mf = "mkfile";
        ch = "chmod";
        smk = "sudomkfile";
        "." = "set hidden!";
        du = "calcdirsize";

        "g." = "cd ~/";
        gd = "cd ~/Documents";
        gD = "cd ~/Downloads";
        gpw = "cd ~/Pictures/wallpapers";
        gT = "cd ~/.local/share/Trash/files";
        gv = "cd ~/Videos";

        r = "rename";
        H = "top";
        L = "bottom";
        R = "reload";
        C = "clear";
        U = "unselect";
        dd = "cut";
        dD = "trash";
        u = "restore";
        m = null;
        "\"'\"" = null;
        "'\"'" = null;
        d = null;
        c = null;
        f = null;
        e = "$$EDITOR \"$f\"";
      };
      commands = {
        open = "%handlr open $f";
        extract = "\${{set -f
                case $f in
                    *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                    *.tar.gz|*.tgz) tar xzvf $f;;
                    *.tar.xz|*.txz) tar xJvf $f;;
                    *.zip) unzip $f;;
                    *.rar) unrar x $f;;
                    *.7z) 7z x $f;;
                esac}}";
        tar = "\${{set -f
                    mkdir $1
                    cp -r $fx $1
                    tar czf $1.tar.gz $1
                    rm -rf $1}}";
        zip = "\${{set -f
                    mkdir $1
                    cp -r $fx $1
                    zip -r $1.zip $1
                    rm -rf $1}}";
        mkdir = "\${{printf \"Directory Name: \"
                    read ans
                    mkdir $ans}}";
        mkfile = "\${{printf \"File Name: \"
                    read ans
                    $EDITOR $ans}}";
        chmod = "\${{printf \"Mode Bits: \"
	                read ans
	                for file in \"$fx\"
	                do
		                chmod $ans $file
	                done}}";
        sudomkfile = "\${{printf \"File Name: \"
            	    read ans
	                sudo $EDITOR $ans}}";
        trash = "%trash-put $fx";
        restore = "%trash-restore";
      };
      previewer = {
        source = "${pkgs.ctpv}/bin/ctpv";
      };
      extraConfig = ''
        &${pkgs.ctpv}/bin/ctpv -s $id
        &${pkgs.ctpv}/bin/ctpvquit $id
      '';
    };

    xdg.configFile."lf/icons" = {
      enable = cfg.lf;
      source = ./source/icons;
    };

    programs.eza = {
      enable = cfg.eza;
      extraOptions = [
        "--group-directories-first"
      ];
      icons = "auto";
      colors = "auto";
      enableZshIntegration = true;
    };

    home.file."${config.xdg.configHome}/eza/theme.yml" = {
      enable = cfg.eza;
      source =
        builtins.fetchGit {
          url = "https://github.com/eza-community/eza-themes.git";
          ref = "main";
          rev = "74be26bbd2ce76b29c37250a2fb7cb5d6644c964";
        }
        + "/themes/dracula.yml";
    };

    programs.hyfetch = {
      enable = cfg.hyfetch;
      settings = {
        preset = "voidgirl";
        mode = "rgb";
        light_dark = "dark";
        lightness = 0.65;
        color_align = {
          mode = "horizontal";
        };
        backend = "fastfetch";
        pride_month_disable = false;
      };
    };

    programs.fastfetch.enable = cfg.hyfetch;
  };
}
