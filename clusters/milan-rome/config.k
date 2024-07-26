import models.k3d.v1alpha5 as k3d
import pkg
import manifests

extraArgs = [{
    arg: "--disable=metrics-server"
    nodeFilters: ["server:*"]
}]
milan = k3d.SimpleConfig {
    metadata.name: "milan"
    servers: 1
    options.k3s.extraArgs: [
        *pkg.podmanDefaults.extraArgs
        *extraArgs
    ]
}

rome = k3d.SimpleConfig {
    metadata.name: "rome"
    servers: 2
    options.k3s.extraArgs: [
        *pkg.podmanDefaults.extraArgs
        *extraArgs
    ]
}

manifests.yaml_stream([milan, rome])
