{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.services.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration =
        if config.alyraffauf.services.ollama.gpu == "amd"
        then "rocm"
        else if config.alyraffauf.services.ollama.gpu == "nvidia"
        then "cuda"
        else null;
      listenAddress = config.alyraffauf.services.ollama.listenAddress;
    };
  };
}
