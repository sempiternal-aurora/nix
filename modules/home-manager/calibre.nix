{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mine.calibre;
  sqlite = "${pkgs.sqlite}/bin/sqlite3";
  tofi = "${pkgs.tofi}/bin/tofi";
  echo = "${pkgs.uutils-coreutils-noprefix}/bin/echo";
  sed = "${pkgs.gnused}/bin/sed";
  handlr = "${pkgs.handlr-regex}/bin/handlr";
  calibredb = "${pkgs.calibre}/bin/calibredb";
  tail = "${pkgs.uutils-coreutils-noprefix}/bin/tail";
  tofi-books = pkgs.writeShellScriptBin "tofi-books" ''
    # Get the list of all titles
    choice=$(
      ${sqlite} -readonly /home/jellyfin/Calibre\ Library/metadata.db "select title from books;" |
      ${tofi} --horizontal false --result-spacing 5 --height 500 --history-file=$XDG_STATE_HOME/tofi-book-history |
      ${sed} -e "s,',\',"
    );

    sqlquery="
      SELECT p.value
      FROM books AS b
      INNER JOIN books_custom_column_1_link AS bp ON b.id = bp.book
      INNER JOIN custom_column_1 AS p ON bp.value = p.id
      WHERE b.title = '$choice';
    ";

    filepath=$(
      ${sqlite} -readonly /home/jellyfin/Calibre\ Library/metadata.db "$sqlquery" |
      ${sed} -e "s,([ \(\)\[\]\'\"]),\\\1,"
    )
    ${handlr} open "$filepath"
  '';
  gen-books-path = pkgs.writeShellScriptBin "gen-books-path" ''
    calires=$(${calibredb} list -f formats | ${tail} -n +2)

    PATHARR=()
    IFS=$'\n'
    for i in $calires; do
      id=$(${echo} "$i" | ${sed} -e "s,^\([0-9]*\).*,\1,")
      path=$(${echo} "$i" | ${sed} -e "s,^[0-9]*\s*,,")
      if [[ "x$id" == "x" ]] then
        PATHARR[-1]="''${PATHARR[-1]} $path"
      else
        PATHARR+=("$id $path")
      fi
    done

    for i in ''${PATHARR[@]}; do
      id=$(${echo} "$i" | ${sed} -e "s,\([0-9]*\).*,\1,")
      filepaths=$(${echo} "$i" | ${sed} -e "s,^[0-9]*,," | ${sed} -e "s,^ \[,,; s,\]$,,; s,([ \(\)\[\]\'\"]),\\\1,; s:, /home:\`/home:")

      IFS=$'\`' read -ra ARR <<< $filepaths
      found=false
      for j in "''${ARR[@]}"; do
        if [[ $j =~ .*\.pdf ]] then
          ${calibredb} set_custom path $id "$j"
          found=true
          break
        fi
      done

      if [[ "x$found" == "xfalse" ]] then
        ${calibredb} set_custom path $id "''${ARR[0]}"
      fi
      IFS=$'\n'
    done
  '';
in
{
  options = {
    mine.calibre.enable = lib.mkEnableOption "install calibre";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.calibre
      tofi-books
      gen-books-path
    ];

    # xdg.configFile."tofi/tofi_books.sh" = {
    #   enable = true;
    #   executable = true;
    #   text = ''
    #     #!/bin/sh
    #
    #     # Get the list of all titles
    #     titles=$(${sqlite} -readonly /home/jellyfin/Calibre\ Library/metadata.db "select title from books;");
    #
    #     choice=$(${echo} "$titles" | ${tofi} --horizontal false --result-spacing 5 --height 500 --history-file=$XDG_STATE_HOME/tofi-book-history | ${sed} -e "s,',\',");
    #
    #     sqlquery="SELECT p.value FROM books AS b INNER JOIN books_custom_column_1_link AS bp ON b.id = bp.book INNER JOIN custom_column_1 AS p ON bp.value = p.id WHERE b.title = '$choice';";
    #
    #     filepath=$(${sqlite} -readonly /home/jellyfin/Calibre\ Library/metadata.db "$sqlquery" | ${sed} -e "s,([ \(\)\[\]\'\"]),\\\1,")
    #     ${handlr} open "$filepath"
    #   '';
    # };
    #
    # xdg.configFile."tofi/gen_books_path.sh" = {
    #   enable = true;
    #   executable = true;
    #   text = ''
    #     #!/bin/sh
    #
    #     calires=$(${calibredb} list -f formats | ${tail} -n +2)
    #
    #     PATHARR=()
    #     IFS=$'\n'
    #     for i in $calires; do
    #         id=$(${echo} "$i" | ${sed} -e "s,^\([0-9]*\).*,\1,")
    #         path=$(${echo} "$i" | ${sed} -e "s,^[0-9]*\s*,,")
    #         if [[ "x$id" == "x" ]] then
    #             PATHARR[-1]="''${PATHARR[-1]} $path"
    #         else
    #             PATHARR+=("$id $path")
    #         fi
    #     done
    #
    #     for i in ''${PATHARR[@]}; do
    #         id=$(${echo} "$i" | ${sed} -e "s,\([0-9]*\).*,\1,")
    #         filepaths=$(${echo} "$i" | ${sed} -e "s,^[0-9]*,," | ${sed} -e "s,^ \[,,; s,\]$,,; s,([ \(\)\[\]\'\"]),\\\1,; s:, /home:\`/home:")
    #
    #         IFS=$'\`' read -ra ARR <<< $filepaths
    #         found=false
    #         for j in "''${ARR[@]}"; do
    #             if [[ $j =~ .*\.pdf ]] then
    #                 ${calibredb} set_custom path $id "$j"
    #                 found=true
    #                 break
    #             fi
    #         done
    #
    #         if [[ "x$found" == "xfalse" ]] then
    #             ${calibredb} set_custom path $id "''${ARR[0]}"
    #         fi
    #         IFS=$'\n'
    #     done
    #   '';
    # };
  };
}
