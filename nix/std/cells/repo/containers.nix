{ inputs, cell }:
let
  inherit (inputs) std;
  l = inputs.nixpkgs.lib // builtins;
  inputsPaths = inputs.omnibus.lib.omnibus.inputsToPaths [
    # because it is not in the input closure of the derivation
    inputs
    (l.removeAttrs cell.pops.configs.load.inputs.inputs [ "self" ])
  ];
in
{
  dev = std.lib.ops.mkDevOCI {
    name = "ghcr.io/hardenedlinux/AISecurity-Research-Template";
    tag = "latest";
    devshell = inputs.cells.repo.shells.default;
    pkgs = [ ];
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
