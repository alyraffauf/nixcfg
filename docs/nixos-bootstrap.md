# Install a NixOS host

This runbook installs or replaces a host that already has a configuration under
`nix/hosts/nixos/`. `nixos-anywhere` runs Disko and erases every disk named in
that host's `disko.nix`. Check the disk path on the target before running the
install command.

Run these commands from the repository root inside `nix develop`.

## Set the host details

Use the target's installer address. Do not put that address in a committed
file. Installer addresses tend to change, and a stale address is a bad thing to
mix with a disk formatter.

```bash
host_name=pacifidlog
target_address=192.0.2.10
target_host="root@$target_address"
host_dir="nix/hosts/nixos/$host_name"
bootstrap_dir=".bootstrap/$host_name"
```

The target needs root SSH access. Use a wired network when the install requires
`nixos-anywhere` to kexec into its own installer.

## Check the disk

Read the disk configuration, then confirm that its stable device path exists on
the target.

```bash
sed -n '1,240p' "$host_dir/disko.nix"
ssh "$target_host" 'ls -l /dev/disk/by-id'
```

Stop if the device in `disko.nix` does not match the disk you intend to erase.
Fix the configuration and validate it again before installing.

## Prepare the SSH host key

Reuse the existing ED25519 private host key when reinstalling the same machine.
This keeps the SSH fingerprint and SOPS recipient unchanged. Put the key and
its public file at these paths:

```text
.bootstrap/<host>/etc/ssh/ssh_host_ed25519_key
.bootstrap/<host>/etc/ssh/ssh_host_ed25519_key.pub
```

Generate a new key when replacing the machine or retiring the old key:

```bash
install -d -m 700 "$bootstrap_dir"
install -d -m 755 "$bootstrap_dir/etc" "$bootstrap_dir/etc/ssh"

ssh-keygen \
  -t ed25519 \
  -N '' \
  -C "root@$host_name" \
  -f "$bootstrap_dir/etc/ssh/ssh_host_ed25519_key"

chmod 600 "$bootstrap_dir/etc/ssh/ssh_host_ed25519_key"
chmod 644 "$bootstrap_dir/etc/ssh/ssh_host_ed25519_key.pub"
install -m 644 \
  "$bootstrap_dir/etc/ssh/ssh_host_ed25519_key.pub" \
  "keys/root_${host_name}.pub"
```

`.bootstrap/` is ignored by Git. Keep it that way. The private key must never
appear in a commit.

## Rekey the secrets

Skip this section when reusing the key already listed in `keys/`. For a new
key, regenerate the SOPS recipients and re-encrypt every secret:

```bash
just sops-rekey
```

Check that the new host key can decrypt each file:

```bash
for secret_file in secrets/*.yaml; do
  SOPS_AGE_SSH_PRIVATE_KEY_FILE="$PWD/$bootstrap_dir/etc/ssh/ssh_host_ed25519_key" \
    sops decrypt --output /dev/null "$secret_file"
done
```

Review the public key, recipient change, and encrypted files. A recipient
change rewrites the SOPS key blocks in every secret.

```bash
git diff -- \
  "keys/root_${host_name}.pub" \
  .sops.yaml \
  secrets
```

## Validate the configuration

Run the full flake check and build the host that will be installed:

```bash
nix fmt
nix flake check
nix build ".#nixosConfigurations.${host_name}.config.system.build.toplevel"
```

Do not deploy or switch a machine to test an installer change.

## Install the host

The facter output path below matches each host's `facter.nix`. The command
writes a fresh hardware report there before it builds and installs the system.
`--extra-files` copies the staged SSH host key to `/etc/ssh` on the new system.
SOPS can then decrypt secrets during the first activation.

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${host_name}" \
  --extra-files "$bootstrap_dir" \
  --generate-hardware-config nixos-facter \
    "$host_dir/facter.json" \
  --target-host "$target_host"
```

This is the destructive step. `nixos-anywhere` formats the configured disks,
installs NixOS, and reboots the target.

## Check the installed host

The installer and installed system use different SSH host keys. Remove the old
installer entry, then compare the installed fingerprint with the public key in
the repository.

```bash
ssh-keygen -R "$target_address"

expected_fingerprint=$(ssh-keygen -lf "keys/root_${host_name}.pub" | awk '{print $2}')
installed_fingerprint=$(
  ssh-keyscan -t ed25519 "$target_address" 2>/dev/null |
    ssh-keygen -lf - |
    awk '{print $2}'
)

test "$installed_fingerprint" = "$expected_fingerprint"
ssh "$target_host" 'hostname; systemctl --failed'
```

Do not accept the new SSH key if the fingerprints differ.

The install changes the local facter report. Refresh the generated host README,
inspect both files, and build once more with the detected hardware:

```bash
bun scripts/generate-host-readmes.ts
git diff -- "$host_dir/facter.json" "$host_dir/README.md"

nix fmt
nix flake check
nix build ".#nixosConfigurations.${host_name}.config.system.build.toplevel"
```

Commit the public key, `.sops.yaml`, all rekeyed secrets, the facter report, and
the generated README together. Leave `.bootstrap/` untracked.
