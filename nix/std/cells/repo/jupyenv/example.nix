{
  pkgs,
  inputs,
  omnibus,
}:
let
  inherit (inputs) main;
in
{
  nixpkgs = inputs.nixpkgs;
  imports = [ omnibus.jupyenv.quarto ];
  publishers.quarto = {
    enable = true;
    runtimeInputs = [
      pkgs.librsvg
      pkgs.tectonic
    ];
  };

  kernel.python.data-science = {
    enable = true;
    # runtimePackages = [
    #   pkgs.just
    #   pkgs.bashInteractive
    #   pkgs.d2
    # ];
    env = inputs.main.devShells.default.passthru.pythonEnv;
  };
  kernel.bash.data-science = {
    enable = true;
    runtimePackages = [ ];
  };
  kernel.julia.data-science = {
    enable = true;
    nixpkgs = inputs.nixpkgs-julia;
    override = {
      augmentedRegistry = inputs.juliaRegistry.outPath;
      makeWrapperArgs = "--prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:/run/opengl-driver-32/lib";
      precompile = false;
      # artifactsOverrides = {
      #   "7e76a0d4-f3c7-5321-8279-8d96eeed0f29" = ["libglvnd"];
      # };
    };
    extraJuliaPackages = [
      "Plots"
      "GLMakie"
      "DataFrames"
    ];
    extraKernelSpc = {
      env = {
        JULIA_NUM_THREADS = "8";
      };
    };
  };
}
