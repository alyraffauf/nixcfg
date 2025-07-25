_: {
  flake.tailscaleACLs = {
    acls = [
      {
        action = "accept";
        dst = ["*:*"];
        src = ["*"];
      }
    ];

    ssh = [
      {
        action = "accept";
        dst = ["autogroup:self"];
        src = ["autogroup:member"];
        users = ["autogroup:nonroot" "root"];
      }
    ];

    nodeAttrs = [
      {
        target = ["100.106.251.41"];
        attr = ["mullvad"];
      }
      {
        target = ["100.76.68.70"];
        attr = ["mullvad"];
      }
      {
        target = ["100.103.102.18"];
        attr = ["mullvad"];
      }
      {
        target = ["100.124.238.118"];
        attr = ["mullvad"];
      }
    ];
  };
}
