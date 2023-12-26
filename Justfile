
jupyterlab+example:
    std //repo/jupyenv/example:run -- "$@"

quarto+example:
    std //repo/jupyenv/example:quarto -- render ./notebook
