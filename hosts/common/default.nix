{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./samba.nix
    ./secrets.nix
    ./wifi.nix
  ];

  environment.systemPackages = with pkgs; [inxi];

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscaleAuthKey.path;
  };
}
