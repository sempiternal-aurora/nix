{
  lib,
  config,
  pkgs,
  ...
}:

{
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;
        history = {
            append = true;
            save = 100000;
            size = 100000;
            share = true;
        };

        shellAliases = {
            lf    = "lfcd";
            pls   = "sudo";
            bocsa = "kitten ssh -i ~/.ssh/ssh-key-2023-07-18.key opc@holonet.myria.dev";
        };
        initExtra = ''
            lfcd () {
                cd "$(command lf -print-last-dir "$@")"
            }
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
        options = [ "--cmd cd" ];
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
				"$docker_context"
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
                disabled = true;
            };

            directory = {
                style = "bg:#DA627D";
                format = "[ $path ]($style)";
                truncation_length = 3;
                truncation_symbol = "…/";
                substitutions = { "Documents" = "󰈙 ";
                    "Downloads" = " ";
                    "Music" = " ";
                    "Pictures" = " ";
                };
            };

            c = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };
            
            elixir = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            elm = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
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
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            gradle = {
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            haskell = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            java = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            julia = {
                symbol = " ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            nodejs = {
                symbol = "";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
            };

            nim = {
                symbol = "󰆥 ";
                style = "bg:#86BBD8";
                format = "[ $symbol ($version) ]($style)";
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

    programs.lf = {
        enable = true;
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
            drawbox = "true";
            ignorecase = "true";
            icons = "true";
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
            open = "%xdg-open $f";
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
        text = ''
colourful: true
# yellow #F1FA8C
# red    #FF5555
# purple #BD93F9
# pink   #FF79C6
# orange #FFB86C
# green  #50FA7B
# cyan   #8BE9FD
# others:
# dark-blue    #6272A4
# foreground   #F8F8F2
# current_line #44475A

filekinds:
  normal: {foreground: "#F8F8F2"}
  directory: {foreground: "#8BE9FD"}
  symlink: {foreground: "#BD93F9"}
  pipe: {foreground: "#6272A4"}
  block_device: {foreground: "#FF5555"}
  char_device: {foreground: "#FF5555"}
  socket: {foreground: "#44475A"}
  special: {foreground: "#FF79C6"}
  executable: {foreground: "#50FA7B"}
  mount_point: {foreground: "#FFB86C"}

perms:
  user_read: {foreground: "#F8F8F2"}
  user_write: {foreground: "#FFB86C"}
  user_execute_file: {foreground: "#50FA7B"}
  user_execute_other: {foreground: "#50FA7B"}
  group_read: {foreground: "#F8F8F2"}
  group_write: {foreground: "#FFB86C"}
  group_execute: {foreground: "#50FA7B"}
  other_read: {foreground: "#F8F8F2"}
  other_write: {foreground: "#FFB86C"}
  other_execute: {foreground: "#50FA7B"}
  special_user_file: {foreground: "#FF79C6"}
  special_other: {foreground: "#6272A4"}
  attribute: {foreground: "#F8F8F2"}

size:
  major: {foreground: "F1FA8C"}
  minor: {foreground: "#BD93F9"}
  number_byte: {foreground: "#F8F8F2"}
  number_kilo: {foreground: "#F8F8F2"}
  number_mega: {foreground: "#8BE9FD"}
  number_giga: {foreground: "#FF79C6"}
  number_huge: {foreground: "#FF79C6"}
  unit_byte: {foreground: "#F8F8F2"}
  unit_kilo: {foreground: "#8BE9FD"}
  unit_mega: {foreground: "#FF79C6"}
  unit_giga: {foreground: "#FF79C6"}
  unit_huge: {foreground: "#FFB86C"}

users:
  user_you: {foreground: "#F8F8F2"}
  user_root: {foreground: "#FF5555"}
  user_other: {foreground: "#FF79C6"}
  group_yours: {foreground: "#F8F8F2"}
  group_other: {foreground: "#6272A4"}
  group_root: {foreground: "#FF5555"}

links:
  normal: {foreground: "#BD93F9"}
  multi_link_file: {foreground: "#FFB86C"}

git:
  new: {foreground: "#50FA7B"}
  modified: {foreground: "#FFB86C"}
  deleted: {foreground: "#FF5555"}
  renamed: {foreground: "#8BE9FD"}
  typechange: {foreground: "#FF79C6"}
  ignored: {foreground: "#6272A4"}
  conflicted: {foreground: "#FF5555"}

git_repo:
  branch_main: {foreground: "#F8F8F2"}
  branch_other: {foreground: "#FF79C6"}
  git_clean: {foreground: "#50FA7B"}
  git_dirty: {foreground: "#FF5555"}

security_context:
  colon: {foreground: "#6272A4"}
  user: {foreground: "#F8F8F2"}
  role: {foreground: "#FF79C6"}
  typ: {foreground: "#6272A4"}
  range: {foreground: "#FF79C6"}

file_type:
  image: {foreground: "#FFB86C"}
  video: {foreground: "#FF5555"}
  music: {foreground: "#50FA7B"}
  lossless: {foreground: "#50FA7B"}
  crypto: {foreground: "#6272A4"}
  document: {foreground: "#F8F8F2"}
  compressed: {foreground: "#FF79C6"}
  temp: {foreground: "#FF5555"}
  compiled: {foreground: "#8BE9FD"}
  build: {foreground: "#6272A4"}
  source: {foreground: "#8BE9FD"}

punctuation: {foreground: "#6272A4"}
date: {foreground: "#FFB86C"}
inode: {foreground: "#F8F8F2"}
blocks: {foreground: "#F8F8F2"}
header: {foreground: "#F8F8F2"}
octal: {foreground: "#50FA7B"}
flags: {foreground: "#FF79C6"}

symlink_path: {foreground: "#BD93F9"}
control_char: {foreground: "#8BE9FD"}
broken_symlink: {foreground: "#FF5555"}
broken_path_overlay: {foreground: "#6272A4"}
        '';
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
