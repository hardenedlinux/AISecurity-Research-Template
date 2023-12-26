{
  description = "My flake with dream2nix packages";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs@{
      self,
      dream2nix,
      nixpkgs,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      # All packages defined in ./packages/<name> are automatically added to the flake outputs
      # e.g., 'packages/hello/default.nix' becomes '.#packages.hello'
      devShells = eachSystem (
        system: { default = self.packages.${system}.default.devShell; }
      );
      packages = eachSystem (
        system: {
          default = dream2nix.lib.evalModules {
            packageSets.nixpkgs = inputs.nixpkgs.legacyPackages.${system};
            modules = [
              ./nix/my-project.nix
              {
                paths.projectRoot = ./.;
                # can be changed to ".git" or "flake.nix" to get rid of .project-root
                paths.projectRootFile = "flake.nix";
                paths.package = "./my_project";
              }
            ];
          };
        }
      );
    };
}
