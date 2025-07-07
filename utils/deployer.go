// deployer.go
// A minimal NixOS deployment tool in Go.
// Usage:
//   go build -o deployer deployer.go
//   FLAKE=. OPERATION=test DEPLOYMENTS=deployments.nix ./deployer

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
)

// Deployment spec for a single host.
type HostSpec struct {
	Output   string `json:"output"`   // flake output name
	Hostname string `json:"hostname"` // SSH host
	User     string `json:"user"`     // SSH user
}

// model 'nix build --json' output.
type BuildResult struct {
	Outputs map[string]string `json:"outputs"`
}

func fatal(format string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, "[deployer] Error: "+format+"\n", args...)
	os.Exit(1)
}

func info(format string, args ...interface{}) {
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
	flake := os.Getenv("FLAKE")
	if flake == "" {
		flake = "."
	}
	op := os.Getenv("OPERATION")
	if op == "" {
		op = "test"
	}
	cfg := os.Getenv("DEPLOYMENTS")
	if cfg == "" {
		cfg = "deployments.nix"
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
		expr := fmt.Sprintf("%s#nixosConfigurations.%s.config.system.build.toplevel", flake, spec.Output)
		data := runJSON("nix", "build", "--no-link", "--json", expr)

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
	for name, spec := range hosts {
		target := fmt.Sprintf("%s@%s", spec.User, spec.Hostname)
		path := outs[name]
		info("Copying %s...", path)
		run("nix", "copy", "--to", "ssh://"+target, path)
	}

	// Activate
	for name, spec := range hosts {
		target := fmt.Sprintf("%s@%s", spec.User, spec.Hostname)
		path := outs[name]
		info("Activating %s on %s...", path, target)
		run("ssh", target, "sudo", path+"/bin/switch-to-configuration", op)
		info("✔ Deployed %s#%s to %s", flake, spec.Output, target)
	}

	info("✔ Deployments complete.")
}
