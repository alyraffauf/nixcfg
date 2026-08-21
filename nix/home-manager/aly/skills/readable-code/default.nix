_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/readable-code".source = skillSource;
    programs.codex.skills."readable-code" = skillSource;
    programs.opencode.skills."readable-code" = skillSource;
    programs.crush.skills."readable-code" = skillSource;
    programs.claude-code.skills."readable-code" = skillSource;
  };
}
