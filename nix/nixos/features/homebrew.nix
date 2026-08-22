_: {
  flake.nixosModules.homebrew = {
    config,
    lib,
    pkgs,
    ...
  }: let
    brewPrefix = "/home/linuxbrew/.linuxbrew";
    brewUser = config.hoenn.features.homebrew.user;
    brewGroup = config.users.users.${brewUser}.group;

    homebrewPackages = with pkgs; [
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
      procps
      util-linux
    ];

    compatibilityCommands = pkgs.buildEnv {
      name = "linuxbrew-compat";
      paths = homebrewPackages;
      pathsToLink = ["/bin"];
    };
  in {
    options.hoenn.features.homebrew = {
      user = lib.mkOption {
        type = lib.types.str;
        default = "aly";
        description = "User who will own and run Homebrew.";
      };
    };

    config = {
      assertions = [
        {
          assertion = builtins.hasAttr brewUser config.users.users;
          message = "hoenn.features.homebrew.user must name an existing user.";
        }
      ];

      environment = {
        sessionVariables = {
          HOMEBREW_CURL_PATH = "/run/current-system/sw/bin/curl";
          HOMEBREW_GIT_PATH = "/run/current-system/sw/bin/git";
          XKB_CONFIG_ROOT = "${pkgs.xkeyboard-config}/share/X11/xkb";
        };

        shellInit = ''
          if [ -x "${brewPrefix}/bin/brew" ]; then
            eval "$("${brewPrefix}/bin/brew" shellenv)"
          fi
        '';

        systemPackages = homebrewPackages ++ [pkgs.ruby];
      };

      programs.fish.shellInit = lib.mkIf config.programs.fish.enable ''
        fish_add_path ${brewPrefix}/bin ${brewPrefix}/sbin
      '';

      programs.nix-ld = {
        enable = true;

        libraries = with pkgs; [
          alsa-lib
          at-spi2-atk
          at-spi2-core
          atk
          bash
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
          libx11
          libxcb
          libxcomposite
          libxcursor
          libxdamage
          libxext
          libxfixes
          libgbm
          libxi
          libxkbcommon
          libxkbfile
          libxrandr
          libxrender
          libxscrnsaver
          libxshmfence
          libxtst
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
          zlib
        ];
      };

      system.activationScripts.linuxbrew = {
        deps = ["users"];
        text = ''
          ${pkgs.coreutils}/bin/mkdir -p ${brewPrefix}
          ${pkgs.coreutils}/bin/chown ${brewUser}:${brewGroup} /home/linuxbrew ${brewPrefix}
          ${pkgs.coreutils}/bin/chmod 755 /home/linuxbrew ${brewPrefix}

          ${pkgs.coreutils}/bin/mkdir -p /bin /usr/bin /usr/share/X11
          for source in ${compatibilityCommands}/bin/*; do
            name=$(${pkgs.coreutils}/bin/basename "$source")
            ${pkgs.coreutils}/bin/ln -sfn "$source" "/bin/$name"
            ${pkgs.coreutils}/bin/ln -sfn "$source" "/usr/bin/$name"
          done
          ${pkgs.coreutils}/bin/ln -sfn ${pkgs.xkeyboard-config}/share/X11/xkb /usr/share/X11/xkb
        '';
      };
    };
  };
}
