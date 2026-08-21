# Assemble the public nvf module and its standalone wrapped package.
{
  inputs,
  lib,
  self,
  ...
}: {
  options.flake.neovimModules.default = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
    description = "The standalone nvf configuration.";
  };

  config.perSystem = {pkgs, ...}: let
    mkNeovim = {
      appName,
      module,
    }: let
      configured = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [module];
      };
      inherit (configured) neovim;
    in
      pkgs.symlinkJoin {
        name = appName;
        paths = [neovim];
        postBuild = ''
          rm "$out/bin/nvim"
          cp --dereference "${neovim}/bin/nvim" "$out/bin/${appName}"
        '';
        meta.mainProgram = appName;
      };
  in {
    packages.nvim = mkNeovim {
      appName = "hoenn-nvim";
      module = self.neovimModules.default;
    };
  };
}
