# 🔄 Syncthing Configuration

This snippet provides centralized Syncthing device and folder configurations for all hosts in the flake.

---

## 📂 Structure

- `default.nix` - Main module that imports device and folder configurations
- `devices.nix` - Defines all Syncthing devices with their IDs
- `folders.nix` - Defines shared folders and which devices sync them

---

## 🛠️ Adding New Devices

When provisioning a new host that should participate in Syncthing synchronization:

1. **Generate Syncthing certificates and device ID**:

   ```bash
   syncthing -generate="$HOSTNAME"
   ```

2. **Extract device ID**:
   - Locate the device ID in the generated `config.xml`
   - The device ID is a long alphanumeric string in the format: `XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX`

3. **Add device to configuration**:
   - Add the new device to the `devices.nix` file with its hostname and device ID
   - Follow the existing format: `"hostname" = {id = "DEVICE-ID-HERE";};`

4. **Configure folder access**:
   - Update `folders.nix` to include the new device in the appropriate folder device lists
   - Add the hostname to the `devices` array for each folder the device should sync

5. **Encrypt certificates**:
   - Encrypt the generated `cert.pem` and `key.pem` using `agenix`
   - Store them in the secrets repository at `github.com/alyraffauf/secrets`
   - Configure the host to use these encrypted certificates in its Syncthing service configuration

---

## 📋 Usage by Hosts

Hosts can reference the centralized device and folder configurations via either **NixOS** or **home-manager**.

```nix
{
  services.syncthing = {
    enable = true;

    settings = {
        devices = config.mySnippets.syncthing.devices;
        folders = config.mySnippets.syncthing.folders;
    };
  };
}
```

This ensures all devices have a consistent view of the Syncthing network topology regardless of the configuration method used.
