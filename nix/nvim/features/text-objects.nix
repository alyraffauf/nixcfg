# Select, move, and swap syntax-aware code objects.
_: {
  flake.neovimModules.default = {
    config.vim.treesitter.textobjects = {
      enable = true;
      setupOpts = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            af = "@function.outer";
            "if" = "@function.inner";
            ac = "@class.outer";
            ic = "@class.inner";
            aa = "@parameter.outer";
            ia = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
            "]a" = "@parameter.inner";
          };
          goto_previous_start = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
            "[a" = "@parameter.inner";
          };
        };
        swap = {
          enable = true;
          swap_next."<leader>a" = "@parameter.inner";
          swap_previous."<leader>A" = "@parameter.inner";
        };
      };
    };
  };
}
