package k3d

import (
    "strings"
    // "list"
    "k3d.io/v1alpha5"
)

// k8s name constraint
#k8sName: string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MaxRunes(63)

#Clusters: [Name=#k8sName]:  v1alpha5.#SimpleConfig & {  
    // Per cluster name specifier
    metadata: name: Name
}

#nodeFilters: v1alpha5.#SimpleConfig.#nodeFilters

#Apply: {
    // input
    clusters: #Clusters

    // Common settings
    set: {
        version?: #k8sName
        options?: {
            k3s?: {
                extraArgs?: [...{
                    arg?:         string
                    nodeFilters?: #nodeFilters
                }]
                nodeLabels?: [...{
                    label?:       string
                    nodeFilters?: #nodeFilters
                }]
            }
        }
    }

    // Rendered k3d clusters
    objects: [ 
        for obj in clusters { 
            #iCluster & {_set: set, _obj: obj}
        }
    ]
}

#iCluster: v1alpha5.#SimpleConfig & {
    _set: _
    _obj: v1alpha5.#SimpleConfig

    if _set.version != _|_ {
        image: "docker.io/rancher/k3s:\(_set.version)"

    }

    // Creepy merge of arrays
    // Join merge specific helpers
    if _set.options.k3s.extraArgs != _|_ {
        options: k3s: extraArgs: (*_obj.options.k3s.extraArgs | []) + _set.options.k3s.extraArgs
    }
    if _obj.options.k3s.extraArgs != _|_ {
        options: k3s: extraArgs: _obj.options.k3s.extraArgs + (*_set.options.k3s.extraArgs | [])
    }

    if _set.options.k3s.nodeLabels != _|_ {
        options: k3s: nodeLabels: (*_obj.options.k3s.nodeLabels | []) + _set.options.k3s.nodeLabels
    }
    if _obj.options.k3s.nodeLabels != _|_ {
        options: k3s: nodeLabels: _obj.options.k3s.nodeLabels + (*_set.options.k3s.nodeLabels | [])
    }

    // options have only k3d and k3s fields
    if _obj.options.k3d != _|_ {
        options: k3d: _obj.options.k3d
    }

    // rest of options
    if _obj.options != _|_ {
        for field, value in _obj.options if field != "k3s" && field != "k3d"
            {
                options: { "\(field)": value  }
            }
    }

    // rest but options
    for field, value in _obj if field != "options"
        { "\(field)": value }
}
