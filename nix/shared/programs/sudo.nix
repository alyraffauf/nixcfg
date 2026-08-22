_: let
  module = {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
in {
  flake = {
    nixosModules.default = module;
    systemModules.default = module;

    darwinModules.default = {
      security = {
        pam.services.sudo_local = {
          reattach = true;
          touchIdAuth = true;
          watchIdAuth = true;
        };

        sudo.extraConfig = ''
          root ALL=(ALL) NOPASSWD: ALL
          %admin ALL=(ALL) NOPASSWD: ALL
        '';
      };
    };
  };
}
