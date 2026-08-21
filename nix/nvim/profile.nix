# Name the profile and expose its vi-compatible launch aliases.
_: {
  flake.neovimModules.default = {
    config = {
      mnw.appName = "hoenn-nvim";
      vim = {
        viAlias = true;
        vimAlias = true;
      };
    };
  };
}
