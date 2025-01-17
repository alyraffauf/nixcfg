{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.chromium.enable {
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
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-3.9.9.0.crx";
            sha256 = "sha256-L1rWhQ3Xi0W53JfuH75Bk6mgDoubXMVMOxxIlpxikS8=";
          };

          version = "3.9.9.0";
        }
      ];

      package = config.ar.home.apps.chromium.package;
    };
  };
}
