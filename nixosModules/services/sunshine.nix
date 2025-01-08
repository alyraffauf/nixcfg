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

    udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660" OPTIONS+="static_node=uinput"
    '';
  };
}
