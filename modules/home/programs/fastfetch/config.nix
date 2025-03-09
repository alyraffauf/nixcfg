{
  "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
  display = {separator = "  ";};
  logo = {
    padding = {
      bottom = 3;
      top = 3;
    };

    type = "small";
  };
  modules = [
    "break"
    "title"
    {
      format = "{5} {1}";
      key = "host  ";
      keyColor = "33";
      type = "host";
    }
    {
      format = "{2}";
      key = "os    ";
      keyColor = "33";
      type = "os";
    }
    {
      format = "{1}d {2}h {3}m";
      key = "uptime";
      keyColor = "33";
      type = "uptime";
    }
    {
      key = "kernel";
      keyColor = "33";
      type = "kernel";
    }
    {
      format = "{1}";
      key = "wm    ";
      keyColor = "33";
      type = "wm";
    }
    {
      format = "{1}";
      key = "cpu   ";
      keyColor = "33";
      type = "cpu";
    }
    {
      format = "{2}";
      key = "gpu   ";
      keyColor = "33";
      type = "gpu";
    }
    {
      key = "memory";
      keyColor = "33";
      type = "memory";
    }
    {
      format = "{1} / {2} ({3})";
      key = "disk  ";
      keyColor = "33";
      type = "disk";
    }
    {
      format = "{5} ({4})";
      key = "bat   ";
      keyColor = "33";
      type = "battery";
    }
    "break"
  ];
}
