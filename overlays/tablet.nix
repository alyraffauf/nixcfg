# Text input fixes for electron apps.
final: prev: {
  brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};

  obsidian = prev.obsidian.overrideAttrs (old: {
    installPhase =
      builtins.replaceStrings ["--ozone-platform=wayland"]
      ["--ozone-platform=wayland --enable-wayland-ime"]
      old.installPhase;
  });

  vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

  webcord = prev.webcord.overrideAttrs (old: {
    installPhase =
      builtins.replaceStrings ["--ozone-platform-hint=auto"]
      ["--ozone-platform-hint=auto --enable-wayland-ime"]
      old.installPhase;
  });
}
