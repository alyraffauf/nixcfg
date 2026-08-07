{
  config,
  lib,
  pkgs,
  ...
}: let
  brewPrefix = "/home/linuxbrew/.linuxbrew";
  ln = "${pkgs.coreutils}/bin/ln";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  chown = "${pkgs.coreutils}/bin/chown";
  chmod = "${pkgs.coreutils}/bin/chmod";

  # Brew sanitizes PATH to /usr/bin:/bin:/usr/sbin:/sbin
  compatEnv = pkgs.buildEnv {
    name = "linuxbrew-compat";
    paths = with pkgs; [
      bash
      coreutils
      curl
      file
      findutils
      gawk
      gcc
      git
      glibc.bin
      gnugrep
      gnused
      gnutar
      gzip
      util-linux
    ];
    pathsToLink = ["/bin"];
  };
in {
  options.myNixOS.profiles.homebrew = {
    enable = lib.mkEnableOption "Homebrew on Linux";

    user = lib.mkOption {
      type = lib.types.str;
      description = "User who will own and run Homebrew.";
    };
  };

  config = lib.mkIf config.myNixOS.profiles.homebrew.enable {
    environment = {
      systemPackages = with pkgs; [
        curl
        glibc.bin
        git
        gzip
        ruby
      ];

      variables = {
        HOMEBREW_CURL_PATH = "/run/current-system/sw/bin/curl";
        HOMEBREW_GIT_PATH = "/run/current-system/sw/bin/git";
      };

      shellInit = ''
        [ -d "${brewPrefix}/bin" ] && export PATH="${brewPrefix}/bin:${brewPrefix}/sbin:$PATH"
      '';
    };

    programs.fish.shellInit = lib.mkIf config.programs.fish.enable ''
      fish_add_path ${brewPrefix}/bin ${brewPrefix}/sbin
    '';

    # Runtime libraries nix-ld exposes to dynamically-linked binaries
    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      fuse3
      gdk-pixbuf
      glib
      gtk3
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libgcrypt
      libglvnd
      libnotify
      libpulseaudio
      libsecret
      libunwind
      libusb1
      libuuid
      libxkbcommon
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      stdenv.cc.cc
      systemd
      vulkan-loader
      wayland
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxkbfile
      libxrandr
      libxrender
      libxscrnsaver
      libxshmfence
      libxtst
      zlib
    ];

    system.activationScripts.linuxbrew = {
      deps = ["users"];
      text = ''
        # Create Homebrew directory owned by the brew user
        ${mkdir} -p /home/linuxbrew/.linuxbrew
        ${chown} ${config.myNixOS.profiles.homebrew.user}: /home/linuxbrew /home/linuxbrew/.linuxbrew
        ${chmod} 755 /home/linuxbrew /home/linuxbrew/.linuxbrew

        # Populate /bin and /usr/bin with the compat tools brew expects
        ${mkdir} -p /bin /usr/bin
        for src in ${compatEnv}/bin/*; do
          name=$(${pkgs.coreutils}/bin/basename "$src")
          ${ln} -sfn "$src" "/bin/$name"
          ${ln} -sfn "$src" "/usr/bin/$name"
        done

        # xkb data at the FHS path libxkbcommon defaults to
        ${mkdir} -p /usr/share/X11
        ${ln} -sfn ${pkgs.xkeyboard-config}/share/X11/xkb /usr/share/X11/xkb
      '';
    };
  };
}
