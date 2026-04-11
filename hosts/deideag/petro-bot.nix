{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "petro_bot";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "sempiternal-aurora";
    repo = "petro_bot";
    rev = "aea38266e9319d01cc5868ad1006876118921e4a";
    hash = "sha256-w6Zm/iF7kCZEds8IAyLHBUWcDDrIdAochkCUYLOmhm8=";
  };

  cargoHash = "sha256-UYdbUYuWyJjQY7nZNDNOcVkrn/IfICYgApojqjjdFdM=";
}
