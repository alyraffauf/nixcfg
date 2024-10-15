{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "adjustor";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "v${version}";
    hash = "sha256-9ONWKI68Llh36giIS6nVKNrZYmNAGMfwW2vgPMFuwXM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    rich
    pyroute2
    fuse
    pygobject3
    dbus-python
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/adjustor/";
    description = "Allows for TDP control of AMD Handhelds under handheld-daemon support";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
