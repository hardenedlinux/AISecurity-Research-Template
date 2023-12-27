
jupyterlab job Flag:
    std //repo/jupyenv/{{job}}:{{Flag}} -- "$@"

quarto+example: d2-example
    std //repo/jupyenv/example:quarto -- render ./notebook

d2-example:
    (d2 fmt ./notebook/flow.d2 && d2 ./notebook/flow.d2)
