{
  pkgs,
  inputs,
  omnibus,
}:
let
  inherit (inputs) main;
in
{
  imports = [ omnibus.jupyenv.quarto ];
  publishers.quarto.enable = true;

  kernel.python.data-science = {
    enable = true;
    env = inputs.main.devShells.default.passthru.pythonEnv;
  };
}
