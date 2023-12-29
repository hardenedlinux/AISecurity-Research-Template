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
    nixpkgs.follows = "omnibusStd/nixpkgs";
    omnibusStd.url = "github:gtrunsec/omnibus/?dir=local";
    omnibus.url = "github:gtrunsec/omnibus";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.devshell.follows = "omnibusStd/devshell";
    std.inputs.n2c.follows = "n2c";
    std.inputs.nixago.follows = "omnibusStd/nixago";

    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    { std, omnibus, ... }@inputs:
    let
      stdLib =
        (omnibus.pops.std {
          inputs.inputs = {
            inherit (inputs) std;
          };
        }).exports.default;
    in
    std.growOn
      {
        inputs =
          inputs
          // ((omnibus.pops.flake.setInitInputs ../lock).inputs)
          // {
            main = omnibus.inputs.flops.inputs.call-flake ../..;
          };
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

          (stdLib.blockTypes.jupyenv "jupyenv")
          (containers "containers")

          (data "config")
          (files "configFiles")

          (nixago "nixago")
        ];
      }
      {
        devShells = inputs.std.harvest inputs.self [
          "repo"
          "shells"
        ];
      };
}
