{ inputs, cell }:
let
  inherit (inputs) nixpkgs omnibus;
  inputs' = (inputs.omnibus.pops.flake.setSystem nixpkgs.system).inputs;
in
(omnibus.pops.jupyenv.addLoadExtender {
  load = {
    src = ./jupyenv;
    inputs = {
      inputs = inputs // {
        inherit (inputs') jupyenv nixpkgs;
      };
    };
  };
}).exports.jupyenvEvalModules
