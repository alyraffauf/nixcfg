{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.chromium.enable = lib.mkEnableOption "chromium web browser";

  config = lib.mkIf config.myHome.aly.programs.chromium.enable {
    programs.chromium = {
      enable = true;

      extensions = [
        {id = "cdglnehniifkbagbbombnjghhcihifij";} # kagi
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "kgcjekpmcjjogibpjebkhaanilehneje";} # karakeep
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden

        rec {
          id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean
          version = "4.2.5.5";

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${version}.crx";
            sha256 = "sha256-uw8ey2zd7hW+qKsSDhPlbJgJOAwvrDX7NDwkyi1XWbw=";
          };
        }
      ];

      package =
        if pkgs.stdenv.isDarwin
        then (lib.mkDefault (pkgs.runCommand "chromium-0.0.0" {} "mkdir $out"))
        else pkgs.chromium;
    };
  };
}
