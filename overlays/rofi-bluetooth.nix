# My personal fork of rofi-bluetooth.
final: prev: {
  rofi-bluetooth =
    prev.rofi-bluetooth.overrideAttrs
    (old: {
      version = "unstable-2024-07-25";

      src = prev.fetchFromGitHub {
        owner = "alyraffauf";
        repo = old.pname;
        rev = "50252e4a9aebe4899a6ef2f7bc11d91b7e4aa8ae";
        sha256 = "sha256-o0Sr3/888L/2KzZZP/EcXx+8ZUzdHB/I/VIeVuJvJks=";
      };
    });
}
