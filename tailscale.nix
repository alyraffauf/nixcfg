{
  acls = [
    {
      action = "accept";
      src = [
        "*"
      ];
      dst = [
        "*:*"
      ];
    }
  ];
  ssh = [
    {
      action = "accept";
      src = [
        "autogroup:member"
      ];
      dst = [
        "autogroup:self"
      ];
      users = [
        "autogroup:nonroot"
        "root"
      ];
    }
  ];
}
