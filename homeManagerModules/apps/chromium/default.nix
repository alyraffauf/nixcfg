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
        {id = "aomidfkchockcldhbkggjokdkkebmdll";} # Redirect Path
        {id = "bfogiafebfohielmmehodmfbbebbbpei";} # Keeper
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "ioalpmibngobedobkmbhgmadaphocjdn";} # OneLogin
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # Todoist
        {id = "lcbjdhceifofjlpecfpeimnnphbcjgnc";} # xBrowserSync
        {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
        {id = "occjjkgifpmdgodlplnacmkejpdionan";} # Autoscroll
        {id = "olhelnoplefjdmncknfphenjclimckaf";} # catppuccin frappe
        # {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      ];
    };
  };
}
