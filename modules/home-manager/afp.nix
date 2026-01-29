{
  stdenvNoCC,
  isabelle,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "AFP";
  version = "2025-1-unstable-2026-01-23";

  src = fetchurl {
    url = "https://foss.heptapod.net/isa-afp/afp-2025-1/-/archive/0477baa439a72eea06f7c575ec05b6f59b1c6c5d/afp-2025-1-0477baa439a72eea06f7c575ec05b6f59b1c6c5d.tar.gz";
    hash = "sha256-xNix7r+3AAXDFpSgxvCNPB/MYJ/VmXIS4WfNhrLCjN4=";
  };

  buildPhase = ''
    export HOME=$TMP
    isabelle components -u $(pwd)/thys
  '';

  nativeBuildInputs = [ isabelle ];

  installPhase = ''
    dir=$out/Isabelle${isabelle.version}/contrib/${finalAttrs.pname}-${finalAttrs.version}
    mkdir -p $dir
    cp -r thys/* $dir/
  '';

  meta = {
    description = "Archive of Formal Proofs";
    homepage = "https://isa-afp.org";
  };
})
