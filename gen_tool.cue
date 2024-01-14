package main

import (
    "encoding/yaml"
    "path"
    "regexp"
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
        regexp.ReplaceAll(".\\w+$", path.Base(input, path.Unix), ""),
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
