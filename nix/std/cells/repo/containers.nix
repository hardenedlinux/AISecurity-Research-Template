{ inputs, cell }:
let
  inherit (inputs) std;
  l = inputs.nixpkgs.lib // builtins;
  inputsPaths =
    inputs.omnibus.lib.omnibus.inputsToPaths
      [
        # because it is not in the input closure of the derivation
        inputs
      ];
in
{
  dev = std.lib.ops.mkDevOCI {
    name = "ghcr.io/hardendlinux/AISecurity-Research-Template";
    tag = "latest";
    devshell = inputs.cells.repo.shells.default;
    preLoadStorePaths = [ ] ++ inputsPaths;
    labels = {
      title = "AISecurity-Research-Template";
      version = "latest";
      url = "https://hardenedlinux.github.io/AISecurity-Research-Template/";
      source = "https://github.com/hardenedlinux/AISecurity-Research-Template";
      description = ''
        A prepackaged container for running the AISecurity-Research-Template
      '';
    };
  };
}
