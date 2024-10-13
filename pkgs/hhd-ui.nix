{
  fetchFromGitHub,
  appimageTools,
  fetchurl,
  hidapi,
  kmod,
  lib,
  python3,
  toybox,
}:
appimageTools.wrapType2 rec {
  pname = "hhd-ui";
  version = "3.2.2";
  src = fetchurl {
    url = "https://github.com/hhd-dev/hhd-ui/releases/download/v${version}/${pname}.AppImage";
    hash = "sha256-RRXVoeWOO/pR+CAEY0J6Buf/RhA+G0PdxGQVMdAHfwA=";
  };

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/hhd-ui/";
    description = "A UI app that can manage Handheld Daemon settings from Steam, the Desktop, and the Web.";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [harryaskham];
    mainProgram = "hhd-ui";
  };
}
