{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./ghostty
    ./git
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    packages = with pkgs; [
      awscli2
      curl
      rclone
      vesktop
    ];

    username = "aly";
  };

  programs = {
    home-manager.enable = true;
  };

  myHome = {
    profiles.shell.enable = true;
    programs.fastfetch.enable = true;
  };
}
