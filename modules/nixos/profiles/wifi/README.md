# Declarative WiFi Connections

WiFi networks can be configured declaratiely in `nixos-profiles-wifi` using `config.networking.networkmanager.ensureProfiles.profiles`, provided by nixpkgs. I also provide helper functions for common wifi security types.

Additionally, [nm2nix](https://github.com/janik-haag/nm2nix) can generate nix expressions for all WiFi networks currently configured in `/etc/NetworkManager/system-connections/` and `/run/NetworkManager/system-connections` with the following command:

```bash
sudo su -c "cd /etc/NetworkManager/system-connections && nix --extra-experimental-features 'nix-command flakes' run github:Janik-Haag/nm2nix | nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nixfmt-rfc-style"
```

Secrets (passwords, certificates, and identities) are supported, but must be declared and available as variables in agenix-encrypted environment files declared with `networking.networkmanager.ensureProfiles.environmentFiles`. These variables will be replaced upon activation with `envsubst`, based on definitions in your secret environment file. Your secrets file will look something like this:

```bash
myWiFiNetworkPSK="mypassword"
myWorkWiFiIdentity="aly"
myWorkWiFiPassword="password123"
```

In short,

1. Manually configure the WiFi network on one device.
1. Export configuration to nix with `nm2nix`.
1. Add secrets to `secrets/wifi.age` as variables (e.g. `MYPSK=1234567890`)
1. Edit the code generated by `nm2nix` to reference `$MYPSK` instead of directly declaring the WPA password.
1. Commit and push changes.
1. Rebuild hosts as required to propogate your new WiFi configuration.