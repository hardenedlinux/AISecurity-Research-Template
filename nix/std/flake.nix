{
  nixConfig = {
    extra-substituters = [
      "https://tweag-topiary.cachix.org"
      "https://tweag-nickel.cachix.org"
      "https://organist.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "tweag-topiary.cachix.org-1:8TKqya43LAfj4qNHnljLpuBnxAY/YwEBfzo3kzXxNY0="
      "tweag-nickel.cachix.org-1:GIthuiK4LRgnW64ALYEoioVUQBWs0jexyoYVeLDBwRA="
      "organist.cachix.org-1:GB9gOx3rbGl7YEh6DwOscD1+E/Gc5ZCnzqwObNH2Faw="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    omnibus.url = "github:gtrunsec/omnibus";
  };
  outputs =
    { omnibus, ... }@inputs:
    let
      inherit (omnibus.flake.inputs) std;
      inputsSource =
        inputs
        // (omnibus.call-flake ../lock).inputs
        // rec {
          inherit std;
          main = omnibus.call-flake ../..;
          nixpkgs = main.inputs.nixpkgs;
        };

      omnibusStd =
        (omnibus.pops.std {
          inputs.inputs = {
            inherit std;
          };
        }).exports.default;
    in
    std.growOn
      {
        inputs = inputsSource;
        cellsFrom = ./cells;

        cellBlocks = with std.blockTypes; [
          (installables "packages")

          (functions "shellsProfiles")
          (devshells "shells")

          (runnables "entrypoints")
          (runnables "scripts")
          (runnables "tasks")

          (functions "lib")

          (functions "packages")

          (functions "pops")

          (omnibusStd.blockTypes.jupyenv "jupyenv")
          (containers "containers")

          (data "config")
          (files "configFiles")

          (nixago "nixago")
        ];
      }
      {
        devShells = std.harvest inputs.self [
          "repo"
          "shells"
        ];
        packages = std.harvest inputs.self [
          "repo"
          "packages"
        ];
      };
}
