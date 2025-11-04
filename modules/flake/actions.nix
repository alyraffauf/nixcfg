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
                    uses = "actions/checkout@v5";
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
                    uses = "actions/checkout@v5";
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
                  uses = "actions/checkout@v5";
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
                  uses = "actions/checkout@v5";
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

      # # build-home-manager.yml
      # ".github/workflows/build-home-manager.yml" = {
      #   name = "build-home-manager";
      #   concurrency = {
      #     cancel-in-progress = true;
      #     group = "\${{ github.workflow }}-\${{ github.ref }}";
      #   };
      #   on = {
      #     push = {
      #       paths-ignore = [
      #         "**/*.md"
      #         ".github/**"
      #         "_img/**"
      #       ];
      #     };
      #     workflow_dispatch = {};
      #   };
      #   jobs =
      #     lib.mapAttrs'
      #     (hostname: _: {
      #       name = "build-${lib.replaceStrings ["@"] ["-"] hostname}";
      #       value = {
      #         runs-on = "ubuntu-latest";
      #         steps = [
      #           {
      #             name = "Free Disk Space (Ubuntu)";
      #             uses = "jlumbroso/free-disk-space@main";
      #           }
      #           {
      #             name = "Checkout";
      #             uses = "actions/checkout@v5";
      #             "with" = {fetch-depth = 1;};
      #           }
      #           {
      #             name = "Install Nix";
      #             uses = "DeterminateSystems/nix-installer-action@main";
      #           }
      #           {
      #             name = "Cachix";
      #             uses = "cachix/cachix-action@master";
      #             "with" = {
      #               name = "alyraffauf";
      #               authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
      #             };
      #           }
      #           {
      #             name = "Build ${hostname}";
      #             run = "nix build --accept-flake-config --print-out-paths .#homeConfigurations.${hostname}.activationPackage";
      #           }
      #         ];
      #       };
      #     })
      #     self.homeConfigurations;
      # };

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
                uses = "actions/checkout@v5";
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
                uses = "actions/checkout@v5";
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
