{pkgs, ...}: {
  hardware.steam-hardware.enable = true;

  programs = {
    gamescope.enable = true;

    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };
}
