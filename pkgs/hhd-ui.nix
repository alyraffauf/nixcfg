{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "hhd-ui";
  version = "3.2.2";
  src = fetchurl {
    url = "https://github.com/hhd-dev/hhd-ui/releases/download/v${version}/${pname}.AppImage";
    hash = "sha256-AFFQBhvWUimNW+LZvIf7bTyOX5GEc60kFSUwpsKqG5A=";
  };

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/hhd-ui/";
    description = "Graphical user interfance for Handheld Daemon settings from Steam, the Desktop, and the Web.";
    platforms = platforms.linux;
    license = licenses.mit;
    mainProgram = "hhd-ui";
  };
}
