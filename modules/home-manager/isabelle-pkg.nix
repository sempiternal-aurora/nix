{
    stdenv,
    lib,
    inputs,
    makeDesktopItem,
    java,
    polyml, 
    veriT, 
    vampire, 
    eprover-ho, 
    nettools,
    ...
}:

stdenv.mkDerivation rec {
    pname = "isabelle";
    version = "2025";

    src = inputs.isabelle;
    
    nativeBuildInputs = [ java ];

    buildInputs = [ polyml veriT vampire eprover-ho nettools ];
        
    desktopItem = makeDesktopItem {
        name = "isabelle";
        exec = "isabelle jedit";
        icon = "isabelle";
        desktopName = "Isabelle";
        comment = meta.description;
        categories = [ "Education" "Science" "Math" ];
    };

    meta = with lib; {
        description = "A generic proof assistant";
        longDescription = ''
            Isabelle is a generic proof assistant.  It allows mathematical formulas
            to be expressed in a formal language and provides tools for proving those
            formulas in a logical calculus.
        '';
        homepage = "https://isabelle.in.tum.de/";
        platforms = platforms.unix;
    };
}
