# 📁 Files

This directory contains files that will be copied to the final file system. It serves as a pseudo file system structure where you can place any files that need to be deployed to NixOS or Darwin systems.

---

## 📂 Directory Structure

The `files/` directory is organized to mirror the target file system structure. For example:

```plaintext
files/
├── etc/           # Files to be placed in /etc/
├── usr/           # Files to be placed in /usr/
└── home/          # Files to be placed in user home directories
```

---

## 🛠️ Usage

Files placed in this directory can be referenced in NixOS or home-manager configurations using `environment.etc`, `home.file`, or similar options.

### Example

To copy a file from `files/etc/example.conf` to `/etc/example.conf`:

```nix
environment.etc."example.conf" = {
  source = ./files/etc/example.conf;
};
```

---
