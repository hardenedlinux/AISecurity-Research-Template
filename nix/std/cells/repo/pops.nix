{ inputs, cell }:
let
  inherit (inputs) nixpkgs omnibus;
  inputs' = (inputs.omnibus.pops.flake.setSystem nixpkgs.system).inputs;
  inherit (inputs.omnibus.pops.self.load.inputs) POP flops;
in
{
  devshellProfiles =
    (inputs.omnibus.pops.devshellProfiles.addLoadExtender {
      load.inputs.inputs = {
        inherit (inputs') nickel;
      };
    }).addExporter
      (
        POP.extendPop flops.haumea.pops.exporter (
          _self: _super: {
            exports = rec {
              inherit (inputs.omnibus.lib.mapPopsExports pops) self;
              pops.self = (
                self.layouts.default.addLoadExtender {
                  load.inputs = {
                    # extend the inputs of the default layout
                    # inherit inputs cell;
                  };
                }
              );
            };
          }
        )
      );
  configs = inputs.omnibus.pops.configs {
    inputs = {
      inputs = {
        inherit (inputs') nixfmt pre-commit-hooks;
        inherit (inputs) std;
        inherit nixpkgs;
      };
    };
  };

  jupyenv = omnibus.pops.jupyenv.addLoadExtender {
    load = {
      src = ./jupyenv;
      inputs = {
        inputs = inputs // {
          inherit (inputs') jupyenv nixpkgs;
        };
      };
    };
  };
}
