{ inputs, cell }:
let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
l.mapAttrs (_: std.lib.dev.mkShell) {
  default =
    { ... }:
    {
      name = "AI Security Researcher Devshell";
      imports = [ cell.pops.devshellProfiles.exports.default.nickel ];

      nixago = [
        cell.nixago.treefmt.default
        cell.nixago.lefthook.default
        cell.nixago.conform.default
      ];

      packages = [
        nixpkgs.tectonic
        nixpkgs.d2
      ] ++ inputs.main.devShells.default.buildInputs;

      commands = [
        {
          name = "std";
          help = std.packages.std.meta.description;
          command = ''
            (cd $PRJ_ROOT/nix/std && ${std.packages.std}/bin/std "$@")
          '';
        }
      ];
    };
}
