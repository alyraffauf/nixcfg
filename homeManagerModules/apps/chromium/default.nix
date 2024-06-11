{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.chromium.enable {
    programs.chromium = {
      enable = true;
      package = config.alyraffauf.apps.chromium.package;
      extensions = [
        {id = "enamippconapkdmgfgjchkhakpfinmaj";} # dearrow
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
        {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
        {id = "olhelnoplefjdmncknfphenjclimckaf";} # catppuccin frappe
      ];
    };
  };
}
