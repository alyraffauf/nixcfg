{lib, ...}: {
  options = {
    mySnippets.syncthing.devices = lib.mkOption {
      description = "List of Syncthing devices.";
      type = lib.types.attrs;

      default = {
        "dewford" = {id = "INSM2ED-2HTKFWC-BXMUOHQ-EFHK7CJ-A44HIG4-LYTGMGU-FRLA2ZS-RZBHAAJ";}; # Retroid Pocket 5
        "fallarbor" = {id = "P4URLH4-YWLMO6J-W62ET7H-TQAO3Y6-T2FAYOY-C2VTI65-VQXHVGG-NQ76PAZ";}; # Framework 13 Intel 11th gen
        "fortree" = {id = "S6PVA3I-EKOCGIU-GFX7AE6-FXM45OW-JTYN5LJ-UZ4LADZ-NNAJGDD-KST2VAG";}; # MacBook Air M2
        "groudon" = {id = "VOEAEAG-NP5Z3BM-DK5FO75-6G4NKSJ-3EUNFSV-VIR4KDH-OM6ZN7L-OOQKCQJ";}; # iPad 10th Gen
        "kyogre" = {id = "SBQNUXS-H4XDJ3E-RBHJPT5-45WDJJA-2U43M4P-23XGUJ7-E3CNNKZ-BXSGIA3";}; # iPhone 12 Pro Max
        "lavaridge" = {id = "RFVF6DA-CQJLXTP-RKMYEB3-D2KMWJH-3Z2CIAN-PNYOXI6-FIDBFWG-JJA57AX";}; # Framework 11th Gen Server
        "lilycove" = {id = "52MTCMC-PKEWSAU-HADMTZU-DY5EKFO-B323P7V-OBXLNTQ-EJY7F7Y-EUWFBQX";}; # Desktop
        "mauville" = {id = "ZAD2MVO-I2OQII4-C3T756B-BEBQMM6-Q4ILH2H-5CR3TMI-DR4VBFD-GLRVOQK";}; # Home server
        "pacifidlog" = {id = "XTEVJX2-DBEFN4X-UCG43YR-V4FOQYU-DMM2WH4-AMCC5FS-42UB3DM-KUDVHQL";}; # ROG Ally X on Bazzite
        "rustboro" = {id = "7CXGPQN-7DYDYJN-DKELOR3-RD4HZUW-SSUDGLZ-WVXYFUT-DPT2MGD-6PO5BQF";}; # Thinkpad t440p
        "slateport" = {id = "MDJFDUG-UJAXQXI-AMEF2AR-PBMD5QK-Z5ZG6AA-RCJCU3M-GZHQQEA-X2JGOAK";}; # homelab
        "sootopolis" = {id = "O6DUUQU-4CXA6IR-2XFL2I4-3PGKI6M-36AIMRM-Y7NKFIX-GDSO4C2-WD4ELAJ";}; # ThinkPad X1 Carbon Gen 9
      };
    };
  };
}
