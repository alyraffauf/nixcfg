{ config, pkgs, ... }:

{
  services = {
    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      shares = {
        Media = {
          comment = "Media @Mauville";
          path = "/mnt/Media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
        };
        Archive = {
          comment = "Archive @Mauville";
          path = "/mnt/Archive";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}

