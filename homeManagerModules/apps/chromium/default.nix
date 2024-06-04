{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.chromium = {
      enable = lib.mkEnableOption "Chromium-based browser with default extensions.";
      package = lib.mkOption {
        description = "Chromium-based browser (Brave by default).";
        default = pkgs.brave;
        type = lib.types.package;
      };
    };
  };

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
