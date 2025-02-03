{...}: {
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        auto-completion = true;
        auto-format = true;
        auto-pairs = false;
        auto-save = true;
        color-modes = true;
        cursorline = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides.render = true;

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };

        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
        };

        statusline.center = ["position-percentage"];
        text-width = 80;
        true-color = true;

        whitespace.characters = {
          newline = "↴";
          tab = "⇥";
        };
      };
    };
  };
}
