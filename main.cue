package main
import "this.sh/k3d"

// Define objects
clusters: k3d.#Clusters
apply: k3d.#Apply

let _clusters = clusters
apply: clusters: _clusters
