# 🖥️ Hosts

This directory contains the NixOS configurations for each of my devices. Each subdirectory corresponds to a specific host, encapsulating its unique setup and specifications.

______________________________________________________________________

## 📂 Directory Structure

The `hosts/` directory is organized as follows:

```plaintext
hosts/
├── fallarbor/     # Framework Laptop 13 (11th Gen Intel)
├── lavaridge/     # Framework Laptop 13 (AMD 7000 Series)
├── lilycove/      # Custom Mini-ITX Gaming Desktop
├── mauville/      # Beelink Mini S12 Pro Home Server
├── petalburg/     # Lenovo Yoga Pro 9i
├── rustboro/      # ThinkPad T440p
└── slateport/     # Lenovo ThinkCentre M700 Tiny
```

______________________________________________________________________

## 🛠️ Provisioning New Devices

To add a new device to this configuration, follow these steps:

1. **Create Host Configuration**:

   - Duplicate an existing host directory within `hosts/` and rename it to the new device's hostname.
   - Modify the `default.nix` and other relevant Nix modules (e.g., `disko.nix`, `hardware.nix`, `home.nix`) to match the new device's specifications.

1. **Update `flake.nix`**:

   - Add the new host to the `nixosConfigurations` section in `flake.nix`.

1. **(Optional) Configure Syncthing**:

   - Generate Syncthing certificates and device ID:
     ```bash
     syncthing -generate="$HOSTNAME"
     ```
   - Locate the device ID in the generated `config.xml` and add it to `modules/nixos/services/syncthing/default.nix`.
   - Encrypt the `cert.pem` and `key.pem` using `agenix` and set them appropriately in the host configuration.

1. **Install NixOS**:

   - Install NixOS on the new device using this flake. Note that secrets will not be available on the first boot without a valid SSH private key.

1. **Authorize SSH Key**:

   - On a separate machine, copy the new system's public SSH key (`/etc/ssh/ssh_host_ed25519_key.pub`) to the host configuration (`secrets/publicKeys/root_$HOSTNAME.pub`).

1. **Rekey Secrets**:

   - Add the new public key to `secrets/secrets.nix`.
   - Rekey all secrets:
     ```bash
     agenix --rekey
     ```
   - Push the changes to the repository.

1. **Rebuild System**:

   - On the new device, rebuild the system from the repository. Secrets will be automatically decrypted and available in `/run/agenix/` for NixOS and `$XDG_RUNTIME_DIR/agenix/` for users.

1. **(Optional) Configure User SSH Key**:

   - Generate a new user SSH key and copy it to `secrets/publicKeys/$USER_$HOSTNAME.pub` to enable passwordless logins to other hosts.

______________________________________________________________________