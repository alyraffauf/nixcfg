_: {
  flake.overlays = {
    default = _final: prev: {
      linuxPackages_latest = prev.linuxPackagesFor (prev.linux_6_16.override {
        argsOverride = rec {
          src = prev.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "IxMRvXCE3DEplE0mu0O+b/g32oL7IQSmdwSuvKi/pp8=";
          };

          version = "6.16.8";
          modDirVersion = "6.16.8";
        };
      });

      qbittorrent-nox = prev.qbittorrent-nox.overrideAttrs (_old: rec {
        version = "5.1.2";

        src = prev.fetchFromGitHub {
          owner = "qbittorrent";
          repo = "qBittorrent";
          rev = "release-${version}";
          hash = "sha256-2hcG2rMwo5wxVQjCEXXqPLGpdT6ihqtt3HsNlK1D9CA=";
        };
      });
    };
  };
}
