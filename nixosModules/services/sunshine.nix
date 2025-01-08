{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    moonlight-qt
  ];

  services = {
    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = true;
    };
  };
}
