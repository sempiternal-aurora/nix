{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  xcursorgen,
  inkscape,
}:
stdenvNoCC.mkDerivation rec {
  pname = "dracula-cursors";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "v${version}";
    hash = "sha256-q3/uBd+jPFhiVAllyhqf486Jxa0mnCDSIqcm/jwGtJA=";
  };
  sourceRoot = "source/kde/cursors/";
  postPatch = ''
    chmod +x build.sh
    patchShebangs build.sh
  '';
  buildPhase = "./build.sh";
  installPhase = ''
    mkdir -p $out/share/icons
    cp -r Dracula-cursors $out/share/icons
  '';

  nativeBuildInputs = [
    xcursorgen
    inkscape
  ];
}
