import models.k3d.v1alpha5 as k3d
import pkg
import manifests

config = k3d.SimpleConfig {
    metadata.name: "play"
    servers: 1
    options.k3s: pkg.podmanDefaults
}

manifests.yaml_stream([config])
