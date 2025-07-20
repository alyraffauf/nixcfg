{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      default = self.packages.${pkgs.system}.installer;

      installer = pkgs.writeShellApplication {
        name = "installer";
        text = builtins.readFile ../utils/installer.sh;
      };

      formatter = pkgs.writeShellApplication {
        name = "formatter";
        runtimeInputs = with pkgs; [
          alejandra
          deadnix
          diffutils
          findutils
          nodePackages.prettier
          rubocop
          shfmt
          statix
        ];
        text = builtins.readFile ../utils/formatter.sh;
      };
    };
  };
}
