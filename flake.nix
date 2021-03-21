{
  description = "Data Science Environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/04f436940c85b68a5dc6b69d93a9aa542cf3bf6c";
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-hardenedlinux = { url = "github:hardenedlinux/nixpkgs-hardenedlinux/master"; flake = false; };
    jupyterWith = { url = "github:GTrunSec/jupyterWith/Mar"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nixpkgs-hardenedlinux, jupyterWith, mach-nix }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          machlib = import mach-nix
            {
              pypiDataRev = "2205d5a0fc9b691e7190d18ba164a3c594570a4b";
              pypiDataSha256 = "1aaylax7jlwsphyz3p73790qbrmva3mzm56yf5pbd8hbkaavcp9g";
              python = "python38";
            };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import (jupyterWith + "/nix/python-overlay.nix"))
              (import (nixpkgs-hardenedlinux + "/nix/python-packages-overlay.nix"))
            ];
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        in
        {
          devShell = import ./devShell.nix { inherit pkgs nixpkgs-hardenedlinux jupyterWith; mach-nix = machlib; };
        }
      )
    );
}
