# Secure Boot + Automatic LUKS decryption

1. Generate secure boot keys:

   ```bash
   sudo nix run nixpkgs#sbctl create-keys
   ```

1. Include `nixos-profiles-lanzaboote` or manually enable lanzaboote in NixOS host configuration:

   ```nix
   boot = {
     initrd.systemd.enable = true; # For automatic decryption with TPM.
     loader.systemd-boot.enable = lib.mkForce false; # Interferes with lanzaboote and must be force-disabled.

     lanzaboote = {
       enable = true;
       pkiBundle = "/var/lib/sbctl";
     };
   };
   ```

1. In UEFI, set secure boot to "setup mode" or erase platform keys.

1. Enroll your secure boot keys:

   ```bash
   sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft
   ```

1. Reboot,  make sure secure boot is enabled in UEFI.

1. Check secure boot status with `bootctl status`:

   ```bash
   System:
         Firmware: UEFI 2.70 (American Megatrends 5.17)
   Firmware Arch: x64
     Secure Boot: enabled (user)
     TPM2 Support: yes
     Measured UKI: yes
     Boot into FW: supported
   ```

1. If your root drive is encrypted with LUKS, you can have the TPM automatically decrypt it on boot:

   ```bash
   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/nvme0n1p2
   ```

   Replace `/dev/nvme0n1p2` with your root partition.
   Check the [Linux TPM PCR Registry](https://uapi-group.org/specifications/specs/linux_tpm_pcr_registry/) for more details.

   **NOTE:** This requires a TPM2 module, devices with prior versions will not work.
