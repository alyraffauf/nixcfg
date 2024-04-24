{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.ollama.enable = lib.mkEnableOption "Enable ollama interface for LLMs.";
    alyraffauf.services.ollama.listenAddress = lib.mkOption {
      description = "Listen Address for Ollama.";
      default = "127.0.0.1:11434";
      type = lib.types.str;
    };
    alyraffauf.services.ollama.gpu = lib.mkOption {
      description = "Type of GPU for enabling GPU acceleration.";
      default = null;
      type = lib.types.str;
    };
  };

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
