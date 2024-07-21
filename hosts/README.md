# Hosts

## Provisioning New Devices

1. Create `hosts/$HOSTNAME/default.nix` and other host-specific nix modules (e.g. `disko.nix`,`hardware.nix`, and `home.nix`).
1. Add host to `nixosConfigurations` in `flake.nix`.
1. (OPTIONAL) Generate a `cert.pem`, `key.pem`, and device ID for Syncthing with `syncthing -generate=$HOSTNAME`. Find the device ID in the generated `config.xml` and add it to `nixosModules/services/syncthing/default.nix`, encrypt the cert and key with agenix, and set them as appropriate in the host configuration.
1. Install NixOS from this flake. Secrets will _not_ be available on first boot without a valid SSH private key.
1. Copy the new system's public SSH key (`/etc/ssh/ssh_host_ed25519_key.pub`) to the host configuration (`secrets/publicKeys/root_$HOSTNAME.pub`).
1. Add the new public key to `secrets/secrets.nix` and rekey all secrets with `agenix --rekey`.
1. Rebuild the new system from git. Secrets will be automatically decrypted and immediately available in `/run/agenix/` for NixOS and `$XDG_RUNTIME_DIR/agenix/` for users.
1. (OPTIONAL) Generate a new user SSH key and add it to `nixosModules/users/default.nix` in order to enable passwordless logins to other hosts.
