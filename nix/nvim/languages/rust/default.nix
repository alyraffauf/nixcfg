# Provide rust-analyzer, rustfmt, Clippy, CodeLLDB, and Rust syntax parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: let
    codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter;
    liblldb =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "${codelldb}/share/lldb/lib/liblldb.dylib"
      else "${codelldb}/share/lldb/lib/liblldb.so";
  in {
    config.vim = {
      globals.hoenn_paths = {
        inherit liblldb;
        codelldb = "${codelldb}/bin/codelldb";
        rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      };
      extraPackages = with pkgs; [cargo clippy rust-analyzer rustfmt];
      formatter.conform-nvim.setupOpts.formatters_by_ft.rust = ["rustfmt"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.rust];
      startPlugins = [pkgs.vimPlugins.rustaceanvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
