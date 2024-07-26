
build:
    #!/bin/bash
    mkdir -p manifests/
    ls -1d clusters/*| while read clusterSet; do
        >&2 echo -e "Writting manifests/$(basename $clusterSet).yaml... To create cluster(s) run:"
        kcl run $clusterSet > manifests/$(basename $clusterSet).yaml
        >&2 echo -e "  k3d cluster create --config manifests/$(basename $clusterSet).yaml\n"
    done
