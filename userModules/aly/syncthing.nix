{
  config,
  lib,
  ...
}: let
  cfg = config.ar.users.aly.syncthing;
in {
  config = lib.mkIf cfg.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.syncthing = {
      enable = true;
      cert = cfg.certFile;
      dataDir = "/home/aly";
      key = cfg.keyFile;
      openDefaultPorts = true;
      user = "aly";
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
          "mauville" = {id = "52MTCMC-PKEWSAU-HADMTZU-DY5EKFO-B323P7V-OBXLNTQ-EJY7F7Y-EUWFBQX";}; # Desktop/homelab b
          "mossdeep" = {id = "3DODR5S-WU6DTH6-Y35QZX7-7OZEOGG-CYVGGCJ-TJ6AOZX-MFDSRCR-NM727A6";}; # Yoga Slim 7x
          "petalburg" = {id = "ECTD3LW-YZTJIXX-HLQYXT7-UGZSGST-3DDKF72-DJPMDHE-SUYDWIT-ASTKTAE";}; # Yoga 9i
          "rustboro" = {id = "7CXGPQN-7DYDYJN-DKELOR3-RD4HZUW-SSUDGLZ-WVXYFUT-DPT2MGD-6PO5BQF";}; # Thinkpad t440p
          "slateport" = {id = "MDJFDUG-UJAXQXI-AMEF2AR-PBMD5QK-Z5ZG6AA-RCJCU3M-GZHQQEA-X2JGOAK";}; # homelab a
          "wallace" = {id = "X55NQL2-H3TEJ5U-EXZPBKQ-LI6BMB4-W2ULDIJ-YNIHJHB-4ISCOJB-UHNLYAX";}; # Samsung a35
          "winona" = {id = "IGAW5SS-WY2QN6J-5TF74YZ-6XPNPTC-RCH3HIT-ZZQKCAI-6L54IS2-SNRIMA2";}; # Pixel Tablet
        };

        folders =
          {
            "sync" = {
              id = "default";
              path = "/home/aly/sync";
              devices = ["brawly" "fallarbor" "gsgmba" "iphone12" "lavaridge" "mauville" "mossdeep" "petalburg" "rustboro" "slateport" "wallace" "winona"];
              versioning = {
                type = "staggered";
                params = {
                  cleanInterval = "3600";
                  maxAge = "1";
                };
              };
            };

            "camera" = {
              id = "fcsgh-dlxys";
              path = "/home/aly/pics/camera";
              devices = ["brawly" "fallarbor" "lavaridge" "mauville" "petalburg" "rustboro" "slateport" "wallace" "winona"];
              versioning = {
                params.cleanoutDays = "5";
                type = "trashcan";
              };
            };

            "screenshots" = {
              id = "screenshots";
              path = "/home/aly/pics/screenshots";
              devices = ["brawly" "fallarbor" "lavaridge" "mauville" "petalburg" "rustboro" "slateport" "wallace" "winona"];
              versioning = {
                params.cleanoutDays = "5";
                type = "trashcan";
              };
            };
          }
          // lib.attrsets.optionalAttrs (config.ar.users.aly.syncthing.syncMusic) {
            "music" = {
              id = "6nzmu-z9der";
              path = config.ar.users.aly.syncthing.musicPath;
              devices = ["lavaridge" "mauville" "petalburg" "rustboro" "wallace"];
            };
          };
      };
    };
  };
}
