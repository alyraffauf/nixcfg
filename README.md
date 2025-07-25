# ❄️ nixcfg

Welcome to my **nixcfg**!

This repository contains my Darwin, NixOS and home-manager configurations, along with whatever custom modules and packages they require. It is modular, declarative, and tailored for multi-device setups. Hopefully, it's as useful to you as it is to me!

---

![](./_img/hyprland.png)

---

## ✨ Features

- **Declarative System & Dotfiles:** Fully declarative management of my macOS (Darwin) + Linux installations and user environments (dotfiles, packages) using Flakes, NixOS, nix-darwin, and home-manager.
- **Multi-Host Configs:** Seamlessly configures my diverse hosts including bare-metal PCs, laptops (Framework, ThinkPad), mini-servers (Beelink), and virtual private servers (Hetzner, Netcup, AWS).
- **Secure Boot & Encryption:** Encrypted boot drives with Secure Boot via `lanzaboote` and automatic LUKS decryption using TPM.
- **Comprehensive Hardware Support:** Meticulously crafted configurations for my (sometimes unique) devices, including custom audio enhancements (Pipewire filter chains) and device-specific power optimizations.
- **Hybrid Cloud Services:** Declarative setup for all the hosts and services that make up my overly complicated homelab, including the \*arr stack, Audiobookshelf, Caddy, Forgejo (my Git forge), Grafana + Loki + Prometheus, Immich, Karakeep, self-hosted AI inference with Ollama, Plex, qBittorrent, Vaultwarden, and more.
- **Automatic Monitoring & Backups:** Easy Prometheus + Loki and Uptime-Kuma setups for system and service monitoring, plus automated Restic backups to Backblaze B2.
- **Robust Networking:** Secure and flexible networking with Tailscale (it's WireGuard), declarative WiFi profiles, and NFS/Samba sharing.
- **Productivity & Development:** Pre-configured tools for development (Git, Helix, VS Code, Zed), shell enhancements (fastfetch, oh-my-posh, zsh), etc.
- **System-Wide Theming:** Consistent aesthetics across devices with stylix, which auto-generates application themes from base16 color schemes.

---

## 📂 Repository Structure

```plaintext
.
├── flake.nix          # Main entry point
├── homes/             # home-manager configurations
├── hosts/             # NixOS and Darwin host configurations
├── modules/           # Modular configurations
│   ├── darwin/        # macOS-specific modules
│   ├── home/          # home-manager modules
│   ├── flake/         # Organized flake components
│   │   ├── darwin.nix       # macOS-specific configurations
│   │   ├── home-manager.nix # Home-manager configurations
│   │   ├── nixos.nix        # NixOS-specific configurations
│   │   └── ...              # Other flake components
│   ├── nixos/         # NixOS-specific modules
│   └── snippets/      # Reusable configuration snippets
└── overlays/          # Custom Nixpkgs overlays
```

---

## 🤝 Contributing

While this is a personal project, I’m open to feedback or suggestions.\
Feel free to open an issue or share ideas that could improve this setup!

---

## 📜 License

This repository is licensed under the **[GNU General Public License](LICENSE.md)**.

---

## 🙌 Acknowledgments

- [nixpkgs](https://github.com/nixos/nixpkgs): 'nough said.
- [agenix](https://github.com/ryantm/agenix): secrets storage and orchestration.
- [disko](https://github.com/nix-community/disko): declarative partitions and disk configuration.
- [home-manager](https://github.com/nix-community/home-manager): declarative dotfile and user package management.
- [hyprland](https://github.com/hyprwm/Hyprland): great dynamic tiling wayland compositor.
- [lanzaboote](https://github.com/nix-community/lanzaboote): secure boot for NixOS.
- [nur](https://github.com/nix-community/NUR): extra packages from the nix user repository.
- [stylix](https://github.com/danth/stylix): system-wide color schemes and typography.

---

## ⭐ Stargazers Over Time

[![Stargazers over time](https://starchart.cc/alyraffauf/nixcfg.svg?variant=adaptive)](https://starchart.cc/alyraffauf/nixcfg)

---
