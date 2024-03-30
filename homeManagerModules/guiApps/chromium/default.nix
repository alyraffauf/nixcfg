{ pkgs, lib, config, ... }: {

  options = {
    guiApps.chromium.enable = lib.mkEnableOption "Enables Chromium.";
  };

  config = lib.mkIf config.guiApps.chromium.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "bfogiafebfohielmmehodmfbbebbbpei"; } # Keeper
        { id = "aomidfkchockcldhbkggjokdkkebmdll"; } # Redirect Path
        { id = "occjjkgifpmdgodlplnacmkejpdionan"; } # Autoscroll
        { id = "ioalpmibngobedobkmbhgmadaphocjdn"; } # OneLogin
        { id = "jldhpllghnbhlbpcmnajkpdmadaolakh"; } # Todoist
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "lcbjdhceifofjlpecfpeimnnphbcjgnc"; } # xBrowserSync
        { id = "olhelnoplefjdmncknfphenjclimckaf"; } # catppuccin frappe
      ];
    };
  };
}
