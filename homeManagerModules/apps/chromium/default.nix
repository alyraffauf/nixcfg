{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.chromium.enable = lib.mkEnableOption "Enables Chromium.";
  };

  config = lib.mkIf config.alyraffauf.apps.chromium.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {id = "bfogiafebfohielmmehodmfbbebbbpei";} # Keeper
        {id = "aomidfkchockcldhbkggjokdkkebmdll";} # Redirect Path
        {id = "occjjkgifpmdgodlplnacmkejpdionan";} # Autoscroll
        {id = "ioalpmibngobedobkmbhgmadaphocjdn";} # OneLogin
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # Todoist
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "lcbjdhceifofjlpecfpeimnnphbcjgnc";} # xBrowserSync
        {id = "olhelnoplefjdmncknfphenjclimckaf";} # catppuccin frappe
      ];
    };
  };
}
