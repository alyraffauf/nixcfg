_: let
  skillSource = import ../_lib.nix ./.;
in {
  flake.homeModules.aly = {
    home.file.".agents/skills/nix".source = skillSource;
    programs.codex.skills.nix = skillSource;
    programs.opencode.skills.nix = skillSource;
    programs.crush.skills.nix = skillSource;
    programs.claude-code.skills.nix = skillSource;
  };
}
