{pkgs, ...}: {
  programs.chromium = {
    enable = true;

    extensions = [
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
      {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
      {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector

      rec {
        id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean
        version = "4.0.7.0";

        crxPath = pkgs.fetchurl {
          url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${version}.crx";
          sha256 = "sha256-YJfkmvHJNvENWYCK3k4vYrJtCijnKOCmQsxGDNxaazQ=";
        };
      }
    ];

    package =
      if pkgs.stdenv.isDarwin
      then (pkgs.runCommand "chromium-0.0.0" {} "mkdir $out")
      else pkgs.chromium;
  };
}
