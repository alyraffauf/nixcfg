_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/gh-cli".source = skillSource;
    programs.codex.skills."gh-cli" = skillSource;
    programs.opencode.skills."gh-cli" = skillSource;
    programs.crush.skills."gh-cli" = skillSource;
    programs.claude-code.skills."gh-cli" = skillSource;
  };
}
