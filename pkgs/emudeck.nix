# This is extremely limited and largely proof-of-concept. Many things will simply not work, including Steam ROM Manager. Expect issues.
{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "emudeck";
  version = "2.3.0";

  src = fetchurl {
    hash = "sha256-BVlATLKbE9wwMs4844UpXCTZsLW1oRFWf9hujVUpa4k=";
    url = "https://github.com/EmuDeck/emudeck-electron/releases/download/v${version}/EmuDeck-${version}.AppImage";
  };

  extraPkgs = pkgs:
    with pkgs; [
      bash
      flatpak
      fuse2
      git
      jq
      newt
      rsync
      unzip
      zenity
    ];

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 {
      inherit pname version src;
    };
  in ''
    install -m 444 -D ${appimageContents}/emudeck.desktop $out/share/applications/emudeck.desktop
    install -m 444 -D ${appimageContents}/emudeck.png \
      $out/share/icons/hicolor/scalable/apps/emudeck.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "EmuDeck utility to manage ROMs on handheld PCs";
    homepage = "https://github.com/EmuDeck/emudeck-electron";
    license = licenses.mit;
    mainProgram = "emudeck";
    platforms = platforms.linux;
  };
}
