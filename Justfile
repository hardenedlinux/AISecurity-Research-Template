
jupyterlab job flag:
    std //repo/jupyenv/{{job}}:{{flag}} -- "$@"

jupyterlab-run:
    #!/usr/bin/env bash
    if [[ -f "$PRJ_ROOT/.env" ]]; then
       source "$PRJ_ROOT/.env"; std //repo/jupyenv/example:run -- --ip 0.0.0.0 --port 8888
    else
       std //repo/jupyenv/example:run -- --ip 0.0.0.0 --port 8888
    fi

quarto job flag: d2-example
    std //repo/jupyenv/{{job}}:quarto -- {{flag}} ./notebook

d2-example:
    (d2 fmt ./notebook/flow.d2 && d2 ./notebook/flow.d2)
