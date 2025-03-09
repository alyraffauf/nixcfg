{
  config,
  lib,
  pkgs,
  ...
}: let
  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    runtimeInputs = [pkgs.coreutils];

    text = ''
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
    '';
  };
in {
  options.myNixOS.services.sunshine.enable = lib.mkEnableOption "sunshine game streaming";

  config = lib.mkIf config.myNixOS.services.sunshine.enable {
    assertions = [
      {
        assertion = config.programs.steam.enable;
        message = "Sunshine requires programs.steam.enable == true.";
      }
    ];

    environment.systemPackages = with pkgs; [
      moonlight-qt
      steam-run-url
    ];

    services = {
      sunshine = {
        enable = true;

        applications = {
          apps = [
            {
              name = "Desktop";
              image-path = "desktop.png";
            }
            {
              auto-detach = "true";
              detached = ["${steam-run-url}/bin/steam-run-url steam://open/bigpicture"];
              image-path = "steam.png";
              name = "Steam";
              output = "steam.txt";
            }
          ];
        };

        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      udev.extraRules = ''
        ## Controller support for Sunshine.
        KERNEL=="uinput", GROUP="input", MODE="0660" OPTIONS+="static_node=uinput"
      '';
    };

    systemd.user.services = {
      steam-run-url-service = {
        enable = true;
        after = ["graphical-session.target"];
        description = "Listen and starts steam games by id.";
        partOf = ["graphical-session.target"];
        path = [config.programs.steam.package];

        script = toString (pkgs.writers.writePython3 "steam-run-url-service" {} ''
          import os
          from pathlib import Path
          import subprocess

          pipe_path = Path(f'/run/user/{os.getuid()}/steam-run-url.fifo')
          try:
              pipe_path.parent.mkdir(parents=True, exist_ok=True)
              pipe_path.unlink(missing_ok=True)
              os.mkfifo(pipe_path, 0o600)
              while True:
                  with pipe_path.open(encoding='utf-8') as pipe:
                      subprocess.Popen(['steam', pipe.read().strip()])
          finally:
              pipe_path.unlink(missing_ok=True)
        '');

        serviceConfig.Restart = "on-failure";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
      };

      sunshine.path = [steam-run-url];
    };
  };
}
