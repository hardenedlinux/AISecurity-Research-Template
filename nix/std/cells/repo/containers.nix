{ inputs, cell }:
let
  inherit (inputs) std stdN2c;
  l = inputs.nixpkgs.lib // builtins;
  inputsPaths = inputs.omnibus.lib.omnibus.inputsToPaths [
    # because it is not in the input closure of the derivation
    (l.recursiveUpdate inputs { main.outPath = ""; })
    cell.pops.configs.load.inputs.inputs
  ];
in
{
  dev = stdN2c.lib.ops.mkDevOCI {
    name = "ghcr.io/hardenedlinux/aisecurity-research-template";
    tag = "latest";
    # avoid missing hash in github action
    reproducible = false;
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
