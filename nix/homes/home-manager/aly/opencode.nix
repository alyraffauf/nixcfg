_: {
  flake.homeModules.aly = {
    programs.opencode = {
      enable = true;

      settings = {
        plugin = [
          "opencode-openai-codex-auth"
          "@warp-dot-dev/opencode-warp"
        ];

        small_model = "opencode/deepseek-v4-flash-free";

        agent = {
          explore.model = "opencode/deepseek-v4-flash-free";
          scout.model = "opencode/deepseek-v4-flash-free";
        };
      };

      tui.theme = "one-dark";
    };
  };
}
