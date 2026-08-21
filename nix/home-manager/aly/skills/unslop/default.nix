_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/unslop".source = skillSource;
    programs.codex.skills.unslop = skillSource;
    programs.opencode.skills.unslop = skillSource;
    programs.crush.skills.unslop = skillSource;
    programs.claude-code.skills.unslop = skillSource;
  };
}
