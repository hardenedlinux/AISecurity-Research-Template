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
  buildPythonPackage.catchConflicts = false;
  deps =
    { nixpkgs, ... }:
    {
      python = nixpkgs.python310;
    };
  public = {
    # devShell = config.deps.mkShell;
    devShellNew = config.public.devShell.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ packageSets.nixpkgs.pdm ];
    });
    env = config.deps.python.withPackages (
      ps: config.mkDerivation.propagatedBuildInputs
    );
  };
}
