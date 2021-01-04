{
  description = "Data Science Environment";
  # nixConfig = {
  #   substituters = [
  #     "http://221.4.35.244:8301/"
  #   ];
  #   trusted-public-keys = [
  #     "221.4.35.244:3ehdeUIC5gWzY+I7iF3lrpmxOMyEZQbZlcjOmlOVpeo="
  #   ];
  # };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/703f052de185c3dd1218165e62b105a68e05e15f";
    julia_15.url = "nixpkgs";
    python37.url = "nixpkgs/4c67f879f0ee0f4eb610373e479a0a9c518c51c4"; #python3.7 tensorflow_2
    nixpkgs-hardenedlinux = { url = "github:hardenedlinux/nixpkgs-hardenedlinux/master"; flake = false; };
    jupyterWith = { url = "github:GTrunSec/jupyterWith/Nov"; flake = false; };
    jupyterWith-overlay = { url = "github:GTrunSec/Jupyter-data-science-environment/master"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nixpkgs-hardenedlinux, jupyterWith, python37, julia_15, jupyterWith-overlay }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              (import (jupyterWith-overlay + "/overlays/python-overlay.nix"))
              (import (jupyterWith-overlay + "/overlays/package-overlay.nix"))
              (import (jupyterWith-overlay + "/overlays/julia-overlay.nix"))
              (import (nixpkgs-hardenedlinux + "/nix/python-packages-overlay.nix"))
            ];
             config = { allowBroken = true; allowUnfree = true; allowUnsupportedSystem = true;
                     };
          };
        in
          {
            devShell = import ./devShell.nix { inherit pkgs nixpkgs-hardenedlinux jupyterWith;};
          }
      )
    );
}
