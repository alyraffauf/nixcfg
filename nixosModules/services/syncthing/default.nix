{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./syncMusic.nix];

  options = {
    alyraffauf.services.syncthing = {
      enable = lib.mkEnableOption "Enable Syncthing";
      user = lib.mkOption {
        description = "Specify user Syncthing runs as.";
        default = "aly";
        type = lib.types.str;
      };
      syncMusic = lib.mkOption {
        description = "Whether to sync music folder.";
        default = true;
        type = lib.types.bool;
      };
      musicPath = lib.mkOption {
        description = "Whether to sync music folder.";
        default = "/home/${config.alyraffauf.services.syncthing.user}/music";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.services.syncthing.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.alyraffauf.services.syncthing.user;
      dataDir = "/home/${config.alyraffauf.services.syncthing.user}";
      settings = {
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1;
        };
        devices = {
          "brawly" = {id = "BBIBWMR-CN4CFC4-2XMPLII-XFWXBT5-EPCZCAF-JOWAX5J-DHIGNM4-O3XQ4Q3";}; # Pixel 6a
          "fallarbor" = {id = "P4URLH4-YWLMO6J-W62ET7H-TQAO3Y6-T2FAYOY-C2VTI65-VQXHVGG-NQ76PAZ";}; # Framework 13 Intel 11th gen
          "gsgmba" = {id = "V2YCZSL-XY7H72L-FGJFWP2-JNYX72O-OJ5V2HY-V4SSSJM-77A7E3Z-7EJFAAV";}; # Work Macbook Air
          "iphone12" = {id = "SBQNUXS-H4XDJ3E-RBHJPT5-45WDJJA-2U43M4P-23XGUJ7-E3CNNKZ-BXSGIA3";}; # iPhone 12 Pro Max
          "lavaridge" = {id = "TMMSCVA-MDJTDPC-PC47NUA-2VPLAIB-6S6MEU7-KALIGUJ-AWDUOUU-XD73MAY";}; # Framework 13 AMD
          "mauville" = {id = "52MTCMC-PKEWSAU-HADMTZU-DY5EKFO-B323P7V-OBXLNTQ-EJY7F7Y-EUWFBQX";}; # Desktop/Homelab
          "mossdeep" = {id = "XRIGHMT-54OGBWP-UAAGAJS-LGTRHA2-EMKOMEB-EJEWKZN-GJFK6FO-3O6KQQ4";}; # Steam Deck OLED
          "petalburg" = {id = "ECTD3LW-YZTJIXX-HLQYXT7-UGZSGST-3DDKF72-DJPMDHE-SUYDWIT-ASTKTAE";}; # Yoga 9i
          "rustboro" = {id = "7CXGPQN-7DYDYJN-DKELOR3-RD4HZUW-SSUDGLZ-WVXYFUT-DPT2MGD-6PO5BQF";}; # Thinkpad t440p
          "wattson" = {id = "B2EYRQJ-LE2FR2J-D4M35TY-FXVGJ6D-USE7S2T-5V357SV-IQQWEAT-RQBLJQB";}; # Samsung a54 5g
          "winona" = {id = "IGAW5SS-WY2QN6J-5TF74YZ-6XPNPTC-RCH3HIT-ZZQKCAI-6L54IS2-SNRIMA2";}; # Pixel Tablet
        };
        folders = {
          "sync" = {
            id = "default";
            path = "/home/${config.alyraffauf.services.syncthing.user}/sync";
            devices = ["brawly" "fallarbor" "gsgmba" "iphone12" "lavaridge" "mauville" "petalburg" "rustboro" "mossdeep" "wattson" "winona"];
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "365";
              };
            };
          };
          "camera" = {
            id = "fcsgh-dlxys";
            path = "/home/${config.alyraffauf.services.syncthing.user}/pics/camera";
            devices = ["brawly" "fallarbor" "lavaridge" "mauville" "petalburg" "rustboro" "wattson" "winona"];
            versioning = {
              params.cleanoutDays = "15";
              type = "trashcan";
            };
          };
        };
      };
    };
  };
}
