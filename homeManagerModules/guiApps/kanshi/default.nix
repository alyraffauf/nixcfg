{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    guiApps.kanshi.enable =
      lib.mkEnableOption "Enable kanshi monitor profiles";
  };

  config = lib.mkIf config.guiApps.kanshi.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      kanshi
    ];

    services.kanshi.enable = true;
    services.kanshi.profiles.lavaridge = {
      outputs = [
        {
          status = "enable";
          criteria = "BOE 0x095F Unknown";
          scale = 1.5;
        }
      ];
    };
    services.kanshi.profiles.petalburg = {
      outputs = [
        {
          status = "enable";
          criteria = "Samsung Display Corp. 0x4152 Unknown";
          scale = 2.0;
        }
      ];
    };
    services.kanshi.profiles.mauville = {
      outputs = [
        {
          status = "enable";
          criteria = "LG Electronics LG ULTRAWIDE 311NTAB5M720";
          scale = 1.2;
          adaptiveSync = false;
        }
      ];
    };
  };
}
