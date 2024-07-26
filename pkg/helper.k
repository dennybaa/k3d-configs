import models.k3d.v1alpha5 as k3d

podmanDefaults = k3d.SimpleConfigOptionsK3S {extraArgs: [{
    arg: "--kubelet-arg=feature-gates=KubeletInUserNamespace=true"
    nodeFilters: ["server:*", "agent:*"]
}]}

