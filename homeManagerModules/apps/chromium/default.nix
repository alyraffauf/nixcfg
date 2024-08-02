{
  config,
  lib,
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
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
      ];
    };
  };
}
