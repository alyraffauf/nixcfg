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

        # Compat symlinks the Homebrew installer expects on standard Linux
        ${mkdir} -p /bin /usr/bin
        ${ln} -sf ${pkgs.bash}/bin/bash          /bin/bash
        ${ln} -sf ${pkgs.coreutils}/bin/basename /bin/basename
        ${ln} -sf ${pkgs.coreutils}/bin/cat      /bin/cat
        ${ln} -sf ${pkgs.coreutils}/bin/chmod    /bin/chmod
        ${ln} -sf ${pkgs.coreutils}/bin/chown    /bin/chown
        ${ln} -sf ${pkgs.coreutils}/bin/chgrp    /bin/chgrp
        ${ln} -sf ${pkgs.coreutils}/bin/dirname  /bin/dirname
        ${ln} -sf ${pkgs.coreutils}/bin/ln       /bin/ln
        ${ln} -sf ${pkgs.coreutils}/bin/mkdir    /bin/mkdir
        ${ln} -sf ${pkgs.coreutils}/bin/mv       /bin/mv
        ${ln} -sf ${pkgs.coreutils}/bin/readlink /bin/readlink
        ${ln} -sf ${pkgs.coreutils}/bin/rm       /bin/rm
        ${ln} -sf ${pkgs.coreutils}/bin/sha256sum /bin/sha256sum
        ${ln} -sf ${pkgs.coreutils}/bin/sort     /bin/sort
        ${ln} -sf ${pkgs.coreutils}/bin/touch    /bin/touch
        ${ln} -sf ${pkgs.coreutils}/bin/uname    /bin/uname
        ${ln} -sf ${pkgs.gnugrep}/bin/grep       /bin/grep
        ${ln} -sf ${pkgs.gnutar}/bin/tar         /bin/tar
        ${ln} -sf ${pkgs.gzip}/bin/gzip          /bin/gzip
        ${ln} -sf ${pkgs.coreutils}/bin/cut      /usr/bin/cut
        ${ln} -sf ${pkgs.coreutils}/bin/dirname  /usr/bin/dirname
        ${ln} -sf ${pkgs.coreutils}/bin/sha256sum /usr/bin/sha256sum
        ${ln} -sf ${pkgs.coreutils}/bin/stat     /usr/bin/stat
        ${ln} -sf ${pkgs.glibc.bin}/bin/ldd      /usr/bin/ldd
        ${ln} -sf ${pkgs.util-linux}/bin/flock   /usr/bin/flock
      '';
    };
  };
}
