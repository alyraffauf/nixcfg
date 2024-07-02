{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.chromium.enable {
    programs.chromium = {
      enable = true;
      package = config.ar.home.apps.chromium.package;
      extensions = [
        {id = "enamippconapkdmgfgjchkhakpfinmaj";} # dearrow
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
        {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
      ];
    };
  };
}
