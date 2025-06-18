{
  config,
  lib,
  pkgs,
  ...
}: let
  engines = import ../firefox/engines.nix;
in {
  options.myHome.aly.programs.zen.enable = lib.mkEnableOption "zen web browser";

  config = lib.mkIf config.myHome.aly.programs.zen.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = lib.optionals pkgs.stdenv.isLinux [pkgs.bitwarden];
      package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);

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
            karakeep
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

          settings =
            (import ../firefox/betterfox/smoothfox.nix)
            // {
              "zen.tabs.vertical.right-side" = true;
              "zen.welcome-screen.seen" = true;
              "zen.workspaces.continue-where-left-off" = true;
            };
        };
      };
    };
  };
}
