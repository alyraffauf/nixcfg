_: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    greedyCasks = true;

    brews = [
      "mas"
      "podman"
    ];

    casks = [
      "ghostty"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
    };

    onActivation = {
      # cleanup = "zap";
      upgrade = true;
    };
  };
}
