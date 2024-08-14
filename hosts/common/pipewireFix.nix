{
  services.pipewire.wireplumber.extraConfig = {
    "10-disable-camera" = {
      "wireplumber.profiles" = {
        main = {
          "monitor.libcamera" = "disabled";
        };
      };
    };
  };
}
