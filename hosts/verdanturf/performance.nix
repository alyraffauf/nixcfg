{...}: {
  boot.tmp.cleanOnBoot = true;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  nix.settings.sandbox = false;

  services.journald = {
    storage = "volatile"; # logs in /run/log/journal
    extraConfig = "SystemMaxUse=32M\nRuntimeMaxUse=32M";
  };
}
