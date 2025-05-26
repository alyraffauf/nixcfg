{
  lib,
  pkgs,
  self,
  ...
}: let
  engines = import ../firefox/engines.nix;
in {
  imports = [
    self.inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };

    profiles = {
      default = {
        containersForce = true;

        containers = {
          personal = {
            color = "purple";
            icon = "circle";
            id = 1;
            name = "Personal";
          };

          private = {
            color = "red";
            icon = "fingerprint";
            id = 2;
            name = "Private";
          };

          atolls = {
            color = "blue";
            icon = "briefcase";
            id = 3;
            name = "Atolls";
          };
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          bitwarden
          consent-o-matic
          ublock-origin
        ];

        id = 0;

        search = {
          inherit engines;
          default = "ddg";
          force = true;

          order = [
            "bing"
            "Brave"
            "ddg"
            "google"
            "Home Manager Options"
            "Kagi"
            "NixOS Wiki"
            "nixpkgs"
            "Noogle"
            "Wikipedia"
            "Wiktionary"
          ];
        };
      };
    };
  };
}
