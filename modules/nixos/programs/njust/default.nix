{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.programs.njust;

  # Merge all recipe files into a single justfile
  mergedJustfileContent = ''
    _default:
        @printf '\033[1;36mnjust\033[0m\n'
        @printf 'Just-based recipe runner for NixOS.\n\n'
        @printf '\033[1;33mUsage:\033[0m njust <recipe> [args...]\n\n'
        @njust --list --list-heading $'Available recipes:\n\n'

    ${lib.concatStringsSep "\n" (lib.attrValues cfg.recipes)}
  '';

  # Validate the justfile syntax
  validatedJustfile =
    pkgs.runCommand "njust-justfile-validated" {
      nativeBuildInputs = [pkgs.just];
      preferLocalBuild = true;
    } ''
      # Write the justfile content to a temporary file
      echo ${lib.escapeShellArg mergedJustfileContent} > justfile

      # Validate the justfile syntax
      echo "Validating njust justfile syntax..."
      just --justfile justfile --summary >/dev/null || {
        echo "ERROR: njust justfile has syntax errors!"
        echo "Justfile content:"
        cat justfile
        exit 1
      }

      # Copy validated justfile to output
      cp justfile $out
      echo "njust justfile validation passed"
    '';

  mergedJustfile = validatedJustfile;

  njustScript = pkgs.writeShellApplication {
    name = "njust";
    runtimeInputs = [pkgs.jq pkgs.just];

    text = ''
      exec just --working-directory "$PWD" --justfile ${mergedJustfile} "$@"
    '';
  };
in {
  options.myNixOS.programs.njust = {
    enable = lib.mkEnableOption "njust helper";

    recipes = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};

      description = ''
        Attribute set of recipe names to justfile content.
        Each recipe will be merged into the final justfile.
      '';
    };

    defaultRecipes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to include default system management recipes";
    };
  };

  config = lib.mkIf cfg.enable {
    myNixOS.programs.njust.recipes = lib.mkIf cfg.defaultRecipes {
      system = ''
        # Show system info
        [group('system')]
        info:
            @echo "Hostname: $(hostname)"
            @echo "NixOS Version: $(nixos-version)"
            @echo "Kernel: $(uname -r)"
            @echo "Generation: $(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1 | awk '{print $1}')"
            @echo "Revision: $(nixos-version --json | jq -r '.configurationRevision // "unknown"')"
      '';

      updates = ''
        # Variables for flatpak conditional logic
        flatpak_check := "command -v flatpak >/dev/null 2>&1"
        flatpak_skip := "echo 'Flatpak not available, skipping'"

        # Update everything
        [group('system')]
        update: update-nix update-flatpaks

        # Update Flatpak apps
        [group('flatpak')]
        update-flatpaks:
            @{{flatpak_check}} && echo "Updating Flatpak applications..." && flatpak update -y || {{flatpak_skip}}

        # Update NixOS system
        [group('nix')]
        update-nix action="switch":
            @echo "Updating NixOS..."
            sudo nixos-rebuild {{action}} --flake "${config.myNixOS.profiles.base.flakeUrl}"
      '';

      secureboot = ''
        # Check Secure Boot status
        [group('secureboot')]
        sb-status:
            sudo bootctl status

        # Generate Secure Boot keys
        [group('secureboot')]
        gen-sb-keys:
            @echo "Generating Secure Boot keys..."
            sudo sbctl create-keys

        # Enroll Secure Boot keys
        [group('secureboot')]
        enroll-sb-keys:
            @echo "Enrolling Secure Boot keys..."
            sudo sbctl enroll-keys --microsoft
      '';
    };

    environment.systemPackages = [njustScript];
  };
}
