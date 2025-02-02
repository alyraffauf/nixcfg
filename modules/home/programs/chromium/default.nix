{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.chromium = {
    package = lib.mkPackageOption pkgs "brave" {};
  };

  config = {
    programs.chromium = {
      enable = true;

      extensions = [
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "enamippconapkdmgfgjchkhakpfinmaj";} # dearrow
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic

        {
          id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-4.0.1.0.crx";
            sha256 = "sha256-n1vt+JKjXQnmA9Ytj2Tfu29yWgfc4EFnzaQ+X+CVqOw=";
          };

          version = "4.0.1.0";
        }
      ];

      package = config.myHome.programs.chromium.package;
    };
  };
}
