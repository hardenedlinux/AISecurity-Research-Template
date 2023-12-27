{
  inputs = {
    juliaRegistry.url = "github:CodeDownIO/General";
    juliaRegistry.flake = false;

    nixpkgs-julia.url = "github:GTrunSec/nixpkgs/julia";
  };
  outputs = _: { };
}
