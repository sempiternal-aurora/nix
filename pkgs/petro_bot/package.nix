{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "petro_bot";
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "PETR0-4LT";
    repo = "petro_bot";
    rev = "f113a1765ae5d3d9f7d9027b0ded6310b518d122";
    hash = "sha256-iz7rESguK+bp5WHgKYbXJ+zRdCfV9KVzEmBtMzMFqL4=";
  };

  cargoHash = "sha256-UYdbUYuWyJjQY7nZNDNOcVkrn/IfICYgApojqjjdFdM=";
}
