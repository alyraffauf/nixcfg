{
  lib,
  self,
  ...
}: {
  flake.actions-nix = {
    pre-commit.enable = true; # Set to true if you want pre-commit workflow generation

    workflows = {
      # build-nix.yml
      ".github/workflows/build-nix.yml" = {
        name = "build-nix";
        concurrency = {
          group = "\${{ github.workflow }}-\${{ github.ref }}";
          cancel-in-progress = true;
        };
        on = {
          push = {
            paths = [
              "flake.lock"
              "flake.nix"
              "flake/"
            ];
          };
          workflow_dispatch = {};
        };
        jobs = let
          devShells = lib.attrNames (self.devShells.x86_64-linux or {});
          packages = lib.attrNames (self.packages.x86_64-linux or {});
          devShellJobs = lib.listToAttrs (map
            (name: {
              name = "build-devShell-${name}";
              value = {
                runs-on = "ubuntu-latest";
                steps = [
                  {
                    uses = "actions/checkout@main";
                    "with" = {fetch-depth = 1;};
                  }
                  {uses = "DeterminateSystems/nix-installer-action@main";}
                  {
                    uses = "cachix/cachix-action@master";
                    "with" = {
                      name = "alyraffauf";
                      authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
                    };
                  }
                  {
                    name = "Build devShell ${name}";
                    run = "nix build --accept-flake-config --print-out-paths .#devShells.x86_64-linux.${name}";
                  }
                ];
              };
            })
            devShells);
          packageJobs = lib.listToAttrs (map
            (name: {
              name = "build-package-${name}";
              value = {
                runs-on = "ubuntu-latest";
                steps = [
                  {
                    uses = "actions/checkout@main";
                    "with" = {fetch-depth = 1;};
                  }
                  {uses = "DeterminateSystems/nix-installer-action@main";}
                  {
                    uses = "cachix/cachix-action@master";
                    "with" = {
                      name = "alyraffauf";
                      authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
                    };
                  }
                  {
                    name = "Build package ${name}";
                    run = "nix build --accept-flake-config --print-out-paths .#packages.x86_64-linux.${name}";
                  }
                ];
              };
            })
            packages);
        in
          devShellJobs // packageJobs;
      };

      # build-darwin.yml
      ".github/workflows/build-darwin.yml" = {
        name = "build-darwin";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs =
          lib.mapAttrs'
          (hostname: _: {
            name = "build-${hostname}";
            value = {
              runs-on = "macos-latest";
              steps = [
                {
                  name = "Checkout";
                  uses = "actions/checkout@main";
                  "with" = {fetch-depth = 1;};
                }
                {
                  name = "Install Nix";
                  uses = "DeterminateSystems/nix-installer-action@main";
                }
                {
                  name = "Cachix";
                  uses = "cachix/cachix-action@master";
                  "with" = {
                    name = "alyraffauf";
                    authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
                  };
                }
                {
                  name = "Build ${hostname}";
                  run = "nix build --accept-flake-config --print-out-paths .#darwinConfigurations.${hostname}.config.system.build.toplevel";
                }
              ];
            };
          })
          self.darwinConfigurations;
      };

      # build-nixos.yml
      ".github/workflows/build-nixos.yml" = {
        name = "build-nixos";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs =
          lib.mapAttrs'
          (hostname: _: {
            name = "build-${hostname}";
            value = {
              runs-on = "ubuntu-latest";
              steps = [
                {
                  name = "Free Disk Space (Ubuntu)";
                  uses = "jlumbroso/free-disk-space@main";
                }
                {
                  name = "Checkout";
                  uses = "actions/checkout@main";
                  "with" = {fetch-depth = 1;};
                }
                {
                  name = "Install Nix";
                  uses = "DeterminateSystems/nix-installer-action@main";
                }
                {
                  name = "Cachix";
                  uses = "cachix/cachix-action@master";
                  "with" = {
                    name = "alyraffauf";
                    authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
                  };
                }
                {
                  name = "Build ${hostname}";
                  run = "nix build --accept-flake-config --print-out-paths .#nixosConfigurations.${hostname}.config.system.build.toplevel";
                }
              ];
            };
          })
          self.nixosConfigurations;
      };

      # check-nix.yml
      ".github/workflows/check-nix.yml" = {
        name = "check-nix";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs = {
          check-flake = {
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@main";
                "with" = {fetch-depth = 1;};
              }
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {
                name = "Check flake evaluation";
                run = "nix -Lv flake check --all-systems";
              }
            ];
          };
        };
      };

      # deploy-tailscale-acls.yml
      ".github/workflows/deploy-tailscale-acls.yml" = {
        name = "deploy-tailscale-acls";
        on = {
          push = {
            branches = ["master"];
            paths = [
              ".github/workflows/deploy-tailscale-acls.yml"
              "flake/tailscale.nix"
            ];
          };
          pull_request = {
            branches = ["master"];
            paths = [
              ".github/workflows/deploy-tailscale-acls.yml"
              "flake/tailscale.nix"
            ];
          };
          workflow_dispatch = {
            inputs = {
              action = {
                description = "Which action to run";
                required = true;
                type = "choice";
                default = "deploy";
                options = ["deploy" "test"];
              };
            };
          };
        };
        jobs = {
          acls = {
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@main";
                "with" = {fetch-depth = 1;};
              }
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {
                name = "Convert .#tailscaleACLs to tailscale.json";
                run = "nix eval --json .#tailscaleACLs > tailscale.json";
              }
              {
                name = "Deploy ACL";
                "if" = ''
                  github.event_name == 'push' ||
                  (github.event_name == 'workflow_dispatch' &&
                   github.event.inputs.action == 'deploy')
                '';
                uses = "tailscale/gitops-acl-action@v1";
                "with" = {
                  api-key = "\${{ secrets.TS_API_KEY }}";
                  tailnet = "alyraffauf.github";
                  policy-file = "tailscale.json";
                  action = "apply";
                };
              }
              {
                name = "Test ACL";
                "if" = ''
                  github.event_name == 'pull_request' ||
                  (github.event_name == 'workflow_dispatch' &&
                   github.event.inputs.action == 'test')
                '';
                uses = "tailscale/gitops-acl-action@v1";
                "with" = {
                  api-key = "\${{ secrets.TS_API_KEY }}";
                  tailnet = "alyraffauf.github";
                  policy-file = "tailscale.json";
                  action = "test";
                };
              }
            ];
          };
        };
      };

      # update-inputs.yml
      ".github/workflows/update-inputs.yml" = {
        name = "update-inputs";
        on = {
          schedule = [
            {cron = "0 6 * * 2,5";}
          ];
          workflow_dispatch = {};
        };
        jobs = {
          update-flake-lock = {
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@main";
                "with" = {
                  ref = "\${{ github.head_ref }}";
                  fetch-depth = 1;
                };
              }
              {
                name = "Setup Git";
                run = ''
                  git config --local user.name  "github-actions[bot]"
                  git config --local user.email  "github-actions[bot]@users.noreply.github.com"
                '';
              }
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {
                uses = "DeterminateSystems/update-flake-lock@main";
                "with" = {
                  token = "\${{ secrets.FLAKE_UPDATE_PAT }}";
                  pr-title = "flake: update inputs";
                  pr-assignees = "alyraffauf";
                  pr-labels = ''
                    dependencies
                    automated
                  '';
                };
              }
            ];
          };
        };
      };
    };
  };
}
