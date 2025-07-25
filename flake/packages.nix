_: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    packages = {
      gen-files = pkgs.writeShellApplication {
        name = "gen-files";

        text = ''
          echo "Configuring your editors..."
          ${lib.getExe config.files.writer.drv}
        '';
      };
    };
  };
}
