{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.services.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration =
        if config.ar.services.ollama.gpu == "amd"
        then "rocm"
        else if config.ar.services.ollama.gpu == "nvidia"
        then "cuda"
        else null;
      listenAddress = config.ar.services.ollama.listenAddress;
    };
  };
}
