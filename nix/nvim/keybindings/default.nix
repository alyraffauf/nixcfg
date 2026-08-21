# Define the shared leader vocabulary and editor-wide window movement keys.
_: {
  flake.neovimModules.default = {
    config.vim = {
      binds.whichKey = {
        enable = true;
        register = {
          "<leader>b" = "+Buffers";
          "<leader>c" = "+Code";
          "<leader>d" = "+Debug";
          "<leader>f" = "+Find";
          "<leader>g" = "+Git";
          "<leader>p" = "+Project";
          "<leader>q" = "+Sessions";
          "<leader>t" = "+Terminal";
          "<leader>v" = "+View";
          "<leader>x" = "+Problems";
        };
      };
      globals = {
        mapleader = " ";
        maplocalleader = ",";
      };
      extraLuaFiles = [./config.lua];
    };
  };
}
