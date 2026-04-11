{
  stdenvNoCC,
  isabelle,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "AFP";
  version = "2025-1-unstable-2026-03-09";

  src = fetchurl {
    url = "https://foss.heptapod.net/isa-afp/afp-2025-1/-/archive/4d71ef8d93bada9fe604ae7a0bea2f42030bd82d/afp-2025-1-4d71ef8d93bada9fe604ae7a0bea2f42030bd82d.tar.gz";
    hash = "sha256-ePHSevyhtpd5GpE8z0OLCicqQMJhuUx2PpJZtAXHlSA=";
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
