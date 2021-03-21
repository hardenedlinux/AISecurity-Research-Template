{ pkgs ? import <nixpkgs> { }
, nixpkgs-hardenedlinux
, jupyterWith
, mach-nix
}:
let
  jupyter = import jupyterWith { inherit pkgs; };

  python-custom = mach-nix.mkPython rec {
    requirements = builtins.readFile ./python-environment.txt;
  };

  iPython = jupyter.kernels.iPythonWith {
    name = "Python-data-env";
    python3 = python-custom.python;
    packages = python-custom.python.pkgs.selectPkgs;
    ignoreCollisions = true;
  };

  CXX = jupyter.kernels.xeusCling {
    name = "cxx-kernel";
    extraFlag = "c++17";
  };


  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [
        iPython
        #CXX
        #iHaskell
      ];
      directory = "./.jupyterlab";
      extraPackages = p: with p;[ python3Packages.jupytext ];
      extraJupyterPath = p: "${p.python3Packages.jupytext}/${p.python3.sitePackages}";
    };

in
pkgs.mkShell rec {
  buildInputs = [
    jupyterEnvironment
    iPython.runtimePackages
  ];

  shellHook = ''
    ${jupyterEnvironment}/bin/jupyter-lab
  '';
}
