{
  callPackage,
  requireFile,
  lib,
  version ? "2.1.1",
  source ? null,
  versionInfo ? null,
}:

let
  versions = import ./versions.nix;

  selected = lib.defaultTo (versions.${version}) versionInfo;
  basename = "st-stm32cubeide_${version}_${selected.buildNumber}_${selected.date}_${selected.magicNumber}_amd64";

  defaultSource = requireFile {
    name = "${basename}.sh.zip";
    message = ''
      This nix expression requires that ${basename}.sh.zip is
      already part of the store. Download it from
      https://www.st.com/en/development-tools/stm32cubeide.html
      (it's the generic linux version) and then add it to the
      store with:
      $ nix store add --mode flat ${basename}.sh.zip
      or
      $ nix-store --add-fixed sha256 ${basename}.sh.zip
    '';
    inherit (selected) hash;
  };

in
callPackage ./generic.nix {
  inherit version basename;
  inherit (selected) stlinkVersion jlinkUdevVersion stlinkUdevVersion;

  src = lib.defaultTo defaultSource source;
}
