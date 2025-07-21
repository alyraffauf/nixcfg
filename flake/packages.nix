{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      default = self.packages.${pkgs.system}.installer;

      installer = pkgs.writeShellApplication {
        name = "installer";
        text = builtins.readFile ../utils/installer.sh;
      };
    };
  };
}
