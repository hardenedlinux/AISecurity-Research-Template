{ pkgs ? import <nixpkgs> {}
, nixpkgs-hardenedlinux
, jupyterWith
}:
let

  jupyter = import jupyterWith { inherit pkgs;};
  env = (import (jupyterWith + "/lib/directory.nix")){ inherit pkgs Rpackages;};
  Rpackages = p: with p; [ ggplot2 dplyr xts purrr cmaes cubature
                           reshape2
                         ];


  iPython = jupyter.kernels.iPythonWith {
    name = "Python-data-env";
    packages = import ./python-packages-list.nix { inherit pkgs;
                                                   MachineLearning = true;
                                                   DataScience = true;
                                                   Financial = true;
                                                   Graph =  true;
                                                   SecurityAnalysis = true;
                                                 };
    ignoreCollisions = true;
  };

  IRkernel = jupyter.kernels.iRWith {
    name = "IRkernel-data-env";
    packages = import ./overlays/R-packages-list.nix { inherit pkgs;};
  };

  CXX = jupyter.kernels.xeusCling {
    name = "cxx-kernel";
    extraFlag = "c++17";
  };


  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython  ];
      extraPackages = p: with p;[ python3Packages.jupytext ];
      extraJupyterPath = p: "${p.python3Packages.jupytext}/${p.python3.sitePackages}";
    };

in
pkgs.mkShell rec {
  buildInputs = [
    #voila
    jupyterEnvironment
    iPython.runtimePackages
  ];
  shellHook = ''
      export PYTHON="${toString iPython.kernelEnv}/bin/python"
      export PYTHONPATH="${toString iPython.kernelEnv}/${pkgs.python3.sitePackages}/"
      ${jupyterEnvironment}/bin/jupyter-lab
  '';
}
