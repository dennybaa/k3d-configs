package main

import (
    "encoding/yaml"
    "path"
    "strings"
    "tool/exec"
    "tool/file"
    "tool/cli"
)

command: gen: {
    input: string @tag(input)
    cueEval: exec.Run & {
        cmd:    ["cue", "eval", "main.cue", input, "--out=yaml"]
        stdout: string
    }

    // k3d resource list
    resources: yaml.Unmarshal(cueEval.stdout).apply.objects

    resultDir: path.Resolve(
        "clusters",
        strings.TrimSuffix(path.Base(input, path.Unix), ".yaml"),
        path.Unix
    )

    // Create clusters/{dest} directory
    mkDir: file.Mkdir & {
        $dep: cueEval.$done
        path: resultDir
        createParents: true
    }

    // Writes k3d configs
    writeConfigs: {
        info: cli.Print & {
            text: "To create clusters run the commands bellow:\n"
        }

        for r in resources {
            "\(r.metadata.name)": {
                configPath: resultDir + "/\(r.metadata.name).yaml",

                write: file.Create & {
                    $dep: mkDir.$done
                    filename: configPath
                    contents: yaml.Marshal(r)
                }

                info: cli.Print & {
                    text: "  k3d cluster create --config \(configPath)"
                }
            }
        }
    }
}
