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

  # Brew sanitizes PATH to /usr/bin:/bin:/usr/sbin:/sbin, so the tools its
  # shims invoke must exist there. Aggregate everything brew touches into
  # one buildEnv and symlink the resulting bin/ contents into /bin and
  # /usr/bin during activation.
  compatEnv = pkgs.buildEnv {
    name = "linuxbrew-compat";
    paths = with pkgs; [
      bash
      coreutils
      curl
      file
      findutils
      gawk
      gcc # provides /usr/bin/cc; brew's gcc postinstall calls it for crti.o
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
      # Packages the Homebrew installer needs at runtime
      systemPackages = with pkgs; [
        curl
        glibc.bin
        git
        gzip
        ruby
      ];

      # Pin curl/git so brew doesn't hunt for them on a sanitized PATH
      variables = {
        HOMEBREW_CURL_PATH = "/run/current-system/sw/bin/curl";
        HOMEBREW_GIT_PATH = "/run/current-system/sw/bin/git";
      };

      # bash/zsh PATH wiring
      shellInit = ''
        [ -d "${brewPrefix}/bin" ] && export PATH="${brewPrefix}/bin:${brewPrefix}/sbin:$PATH"
      '';
    };

    # fish PATH wiring
    programs.fish.shellInit = lib.mkIf config.programs.fish.enable ''
      fish_add_path ${brewPrefix}/bin ${brewPrefix}/sbin
    '';

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
      '';
    };
  };
}
