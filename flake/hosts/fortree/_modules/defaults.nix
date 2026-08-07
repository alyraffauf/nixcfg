_: {
  system.defaults = {
    LaunchServices.LSQuarantine = false;

    CustomUserPreferences = {
      NSGlobalDomain.WebKitDeveloperExtras = true;

      "com.apple.desktopservices" = {
        # No .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.screencapture" = {
        # Don't dump screenshots on Desktop
        location = "~/Pictures/screenshots";
        type = "png";
      };

      # Separate spaces per monitor
      "com.apple.spaces"."spans-displays" = 0;
    };
  };
}
