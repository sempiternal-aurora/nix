{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "petro_bot";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "PETR0-4LT";
    repo = "petro_bot";
    rev = "6c760e23a270a75345c0eef86ee00c4189116bf7";
    hash = "sha256-w6Zm/iF7kCZEds8IAyLHBUWcDDrIdAochkCUYLOmhm8=";
  };

  cargoHash = "sha256-UYdbUYuWyJjQY7nZNDNOcVkrn/IfICYgApojqjjdFdM=";
}
