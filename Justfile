
jupyterlab job Flag:
    std //repo/jupyenv/{{job}}:{{Flag}} -- "$@"

quarto+example:
    std //repo/jupyenv/example:quarto -- render ./notebook
