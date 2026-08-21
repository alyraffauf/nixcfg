_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/teach".source = skillSource;
    programs.codex.skills.teach = skillSource;
    programs.opencode.skills.teach = skillSource;
    programs.crush.skills.teach = skillSource;
    programs.claude-code.skills.teach = skillSource;
  };
}
