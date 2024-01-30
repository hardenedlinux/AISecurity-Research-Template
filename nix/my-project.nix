{
  config,
  dream2nix,
  lib,
  packageSets,
  ...
}:
let
  src = config.paths.projectRoot;
in
{
  imports = [ dream2nix.modules.dream2nix.WIP-python-pdm ];
  pdm.lockfile = src + /pdm.lock;
  pdm.pyproject = src + /pyproject.toml;
  mkDerivation = {
    inherit src;
    buildInputs = [ config.deps.python.pkgs.pdm-backend ];
  };
  deps =
    { nixpkgs, ... }:
    {
      python = nixpkgs.python310;
      mkShell =
        let
          pythonEnv = (config.deps.python.withPackages (ps: config.mkDerivation.propagatedBuildInputs));
        in
        nixpkgs.mkShell {
          buildInputs = [
            nixpkgs.pdm
            pythonEnv
          ];
          passthru = {
            inherit pythonEnv;
          };
        };
    };
  public = {
    devShell = config.deps.mkShell;
  };
}
