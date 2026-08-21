_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/bro".source = skillSource;
    programs.codex.skills.bro = skillSource;
    programs.opencode.skills.bro = skillSource;
    programs.crush.skills.bro = skillSource;
    programs.claude-code.skills.bro = skillSource;
  };
}
