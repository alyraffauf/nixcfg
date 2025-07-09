// deployer.go
// A minimal NixOS deployment tool in Go.
// Usage:
//   go build -o deployer deployer.go
//   ./deployer --flake github:alyraffauf/nixcfg --operation test --deployments deployments.nix

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"sync"
)

// Deployment spec for a single host.
type HostSpec struct {
	Output   string `json:"output"`   // flake output
	Hostname string `json:"hostname"` // ssh host
	Type     string `json:"type"`     // type (nixos, darwin)
	User     string `json:"user"`     // ssh user
}

// model 'nix build --json' output.
type BuildResult struct {
	Outputs map[string]string `json:"outputs"`
}

func fatal(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "[deployer] Error: "+format+"\n", args...)
	os.Exit(1)
}

func info(format string, args ...any) {
	fmt.Printf("[deployer] "+format+"\n", args...)
}

func runJSON(cmd string, args ...string) []byte {
	c := exec.Command(cmd, args...)
	out, err := c.Output() // only capture stdout
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			fatal("`%s %v` failed: %s", cmd, args, string(ee.Stderr))
		}
		fatal("`%s %v` failed: %v", cmd, args, err)
	}
	return out
}

func run(cmd string, args ...string) []byte {
	c := exec.Command(cmd, args...)
	out, err := c.CombinedOutput()
	if err != nil {
		fatal("`%s %v` failed: %s", cmd, args, string(out))
	}
	return out
}

func main() {
	flakeFlag := flag.String("flake", "", "Flake specification")
	opFlag := flag.String("operation", "", "Operation to perform")
	cfgFlag := flag.String("deployments", "", "Path to deployments file")
	flag.Parse()

	flake := *flakeFlag
	op := *opFlag
	cfg := *cfgFlag

	if flake == "" {
		flake = os.Getenv("FLAKE")
		if flake == "" {
			flake = "."
		}
	}

	if op == "" {
		op = os.Getenv("OPERATION")
		if op == "" {
			op = "test"
		}
	}

	if cfg == "" {
		cfg = os.Getenv("DEPLOYMENTS")
		if cfg == "" {
			cfg = "deployments.nix"
		}
	}

	info("Flake: %s", flake)
	info("Operation: %s", op)
	info("Config: %s", cfg)

	// Load deployment specs (JSON-only)
	data := runJSON("nix", "eval", "--json", "-f", cfg)
	hosts := make(map[string]HostSpec)
	if err := json.Unmarshal(data, &hosts); err != nil {
		fatal("invalid JSON in %s: %v", cfg, err)
	}

	// Build closures
	outs := make(map[string]string, len(hosts))
	for name, spec := range hosts {
		info("Building %s#%s...", flake, spec.Output)

		var data []byte

		switch spec.Type {
		case "darwin":
			expr := fmt.Sprintf("%s#darwinConfigurations.%s.config.system.build.toplevel", flake, spec.Output)
			data = runJSON("nix", "build", "--no-link", "--json", expr)
		case "nixos":
			expr := fmt.Sprintf("%s#nixosConfigurations.%s.config.system.build.toplevel", flake, spec.Output)
			data = runJSON("nix", "build", "--no-link", "--json", expr)
		default:
			fatal("unsupported system type: %s", spec.Type)
		}

		var res []BuildResult
		if err := json.Unmarshal(data, &res); err != nil {
			fatal("bad build JSON for %s: %v", name, err)
		}
		if len(res) == 0 {
			fatal("no outputs for %s", name)
		}
		out, ok := res[0].Outputs["out"]
		if !ok {
			fatal("missing 'out' for %s", name)
		}
		outs[name] = out
		info("✔ Built: %s", out)
	}

	// Copy closures
	var wg sync.WaitGroup
	for name, spec := range hosts {
		wg.Add(1)
		go func(name string, spec HostSpec) {
			defer wg.Done()
			target := fmt.Sprintf("%s@%s", spec.User, spec.Hostname)
			path := outs[name]
			info("Copying %s to %s...", path, target)
			run("nix", "copy", "--to", "ssh://"+target, path)
			info("✔ Copied %s to %s", path, target)
			info("Deploying %s#%s to %s...", flake, spec.Output, target)

			switch spec.Type {
			case "darwin":
				run("ssh", target, "sudo", path+"/activate")
				// ignores user-supplied operation (for now).
				// TODO: handle operation as does darwin-rebuild.
			case "nixos":
				run("ssh", target, "sudo", path+"/bin/switch-to-configuration", op)
			default:
				fatal("unsupported system type: %s", spec.Type)
			}

			info("✔ Deployed %s#%s to %s", flake, spec.Output, target)
		}(name, spec)
	}

	wg.Wait()
	info("✔ Deployments complete.")
}
