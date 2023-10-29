package v1alpha5

#SimpleConfig: {
	// SimpleConfig
	@jsonschema(schema="http://json-schema.org/draft-07/schema#")
	apiVersion: "k3d.io/v1alpha5" | *"k3d.io/v1alpha5"
	kind:       "Simple" | *"Simple"
	metadata?: {
		// Name of the cluster (must be a valid hostname and will be
		// prefixed with 'k3d-'). Example: 'mycluster'.
		name?: string
	}
	servers?: >=1
	agents?:  >=0
	kubeAPI?: {
		host?:     string
		hostIP?:   string
		hostPort?: string
	}
	image?:   string
	network?: string
	subnet?:  string | *"auto"
	token?:   string
	volumes?: [...{
		volume?:      string
		nodeFilters?: #nodeFilters
	}]
	ports?: [...{
		port?:        string
		nodeFilters?: #nodeFilters
	}]
	options?: {
		k3d?: {
			wait?:                bool | *true
			timeout?:             _
			disableLoadbalancer?: bool | *false
			disableImageVolume?:  bool | *false
			disableRollback?:     bool | *false
			loadbalancer?: configOverrides?: [...]
		}
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
		kubeconfig?: {
			updateDefaultKubeconfig?: bool | *true
			switchCurrentContext?:    bool | *true
		}
		runtime?: {
			gpuRequest?:    string
			serversMemory?: string
			agentsMemory?:  string
			hostPidMode?:   bool | *false
			labels?: [...{
				label?:       string
				nodeFilters?: #nodeFilters
			}]
			ulimits?: [...{
				name?: string
				soft?: number
				hard?: number
			}]
			...
		}
	}
	env?: [...{
		envVar?:      string
		nodeFilters?: #nodeFilters
	}]
	registries?: {
		// Create a new container image registry alongside the cluster.
		create?: {
			name?:     string
			host?:     string | *"0.0.0.0"
			hostPort?: string | *"random"
			image?:    string | *"docker.io/library/registry:2"
			proxy?: {
				remoteURL?: string
				username?:  string
				password?:  string
			}
			volumes?: [...string]
		}

		// Connect another container image registry to the cluster.
		use?: [...string]

		// Reference a K3s registry configuration file or at it's contents
		// here.
		config?: string
		...
	}

	// Additional IP to multiple hostnames mappings
	hostAliases?: [...{
		ip?: string
		hostnames?: [...string]
		...
	}]

	#nodeFilters: [...string]
}
