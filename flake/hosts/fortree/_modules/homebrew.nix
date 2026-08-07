_: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    greedyCasks = true;

    brews = [
      "ghostty"
      "mas"
      "podman"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
    };

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
  };
}
