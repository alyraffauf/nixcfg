{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "adjustor";
  version = "3.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    hash = "sha256-0ZrWkfwNKxyUI/l5MDNtFa16I8F+J9p4+4GPE/eXHGY=";
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "v${version}";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    fuse
    pygobject3
    pyroute2
    rich
    setuptools
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  meta = with lib; {
    description = "TDP control of AMD Handhelds with handheld-daemon.";
    homepage = "https://github.com/hhd-dev/adjustor/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
