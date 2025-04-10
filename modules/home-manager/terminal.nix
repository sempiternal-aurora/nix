{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.weechat
    pkgs.zip
    pkgs.unzip
    pkgs.mercurial
    pkgs.trash-cli
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls = [
      {url = "https://archlinux.org/feeds/news/";}
      {url = "https://www.kernel.org/feeds/kdist.xml";}
      {url = "https://www.sandraandwoo.com/feed";}
      {url = "https://www.theshovel.com.au/rss";}
      {url = "https://foxes-in-love.tumblr.com/rss";}
      {url = "https://another-piece-of-candy.thecomicseries.com/rss";}
      {url = "https://trick.pika.page/posts_feed";}
      {url = "https://xkcd.com/atom.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCo0-VCHchPIG3JtJlIQnFew";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC0e3QhIYukixgh5VVpKHH9Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCePQNin7n0WbY9tEts6oGnw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClt01z1wHHT7c5lKcU8pxRQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCpa-Zb0ZcQjTCPP1Dx_1M8Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCFQMnBA3CS502aghlcr0_aw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC3XTzVzaHQEd30rQbuvCtTQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCmtyQOKKmrMVaKuRXz02jbQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCICVWhQj3-pqLt45Ww32ARg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCFhXFikryT4aFcLkLw2LBLA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfPUcG3oCmXEYgdFuwlFh8w";}
    ];
  };

  programs.spotify-player.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
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
    initExtra = ''
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
      bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search
      bindkey -M vicmd "$terminfo[kcuu1]" up-line-or-beginning-search
      bindkey -M vicmd "^[[A" up-line-or-beginning-search
      bindkey -M vicmd "k" up-line-or-beginning-search
      bindkey -M vicmd "$terminfo[kcud1]" down-line-or-beginning-search
      bindkey -M vicmd "^[[B" down-line-or-beginning-search
      bindkey -M vicmd "j" down-line-or-beginning-search

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
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.btop = {
    enable = true;
    settings.color_theme = "dracula";
  };

  programs.starship = {
    enable = true;
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
    enable = true;
    settings = {
      manager = {
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
  };

  programs.lf = {
    enable = false;
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
    enable = false;
    source = ./source/icons;
  };

  programs.eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
    ];
    icons = "auto";
    colors = "auto";
    enableZshIntegration = true;
  };

  home.file."${config.xdg.configHome}/eza/theme.yml" = {
    enable = true;
    source =
      builtins.fetchGit {
        url = "https://github.com/eza-community/eza-themes.git";
        ref = "main";
        rev = "74be26bbd2ce76b29c37250a2fb7cb5d6644c964";
      }
      + "/themes/dracula.yml";
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "nonbinary";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "horizontal";
      };
      backend = "fastfetch";
    };
  };

  programs.fastfetch.enable = true;
}
