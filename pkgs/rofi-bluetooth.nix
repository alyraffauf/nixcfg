{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bc,
  bluez,
}:
stdenv.mkDerivation {
  pname = "rofi-bluetooth";
  version = "unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "alyraffauf";
    repo = "rofi-blueooth";
    rev = "50252e4a9aebe4899a6ef2f7bc11d91b7e4aa8ae";
    sha256 = "sha256-o0Sr3/888L/2KzZZP/EcXx+8ZUzdHB/I/VIeVuJvJks=";
  };

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-bluetooth

    wrapProgram $out/bin/rofi-bluetooth \
      --prefix PATH ":" ${lib.makeBinPath [bc bluez]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rofi-based interface to connect to bluetooth devices and display status info";
    homepage = "https://github.com/alyraffauf/rofi-bluetooth";
    license = licenses.gpl3Only;
    mainProgram = "rofi-bluetooth";
    platforms = platforms.linux;
  };
}
