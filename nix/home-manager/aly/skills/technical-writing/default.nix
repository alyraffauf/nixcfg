_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/technical-writing".source = skillSource;
    programs.codex.skills."technical-writing" = skillSource;
    programs.opencode.skills."technical-writing" = skillSource;
    programs.crush.skills."technical-writing" = skillSource;
    programs.claude-code.skills."technical-writing" = skillSource;
  };
}
