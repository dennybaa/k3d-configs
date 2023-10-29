# cue-lang tool to generate k3d config files

This is just a helper tool to generate k3d config files. It might be a little value in it, since it's been created just to play with CUE lang.

Actually the purpose was to try to add the bellow option into multiple clusters automatically:

```yaml
extraArgs:
  - arg: --kubelet-arg=feature-gates=KubeletInUserNamespace=true
    nodeFilters:
      - all:*
```

This setting is required to run k3d clusters on rootless podman (valid in my case for podman 4.6.2).

## Usage

First download follow the [link to download cue](https://github.com/cue-lang/cue/releases/).

Please look at the example in [values/samle.yaml]. The `clusters.{name}` objects define [k3d configfiles](https://k3d.io/v5.1.0/usage/configfile/) to generate. Note that there is `apply.set` helper to provide common settings for created clusters.

Note: only common `options.k3s` can be provided.

Following the command bellow to generate the configs (output is written into `clusters/sample`):

```shell
cue cmd -t input=values/sample.yaml gen
```

Output:

```
To create clusters run the commands bellow:

  k3d cluster create --config clusters/sample/rome.yaml
  k3d cluster create --config clusters/sample/milan.yaml
```
