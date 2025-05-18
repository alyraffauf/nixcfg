{
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

      users = [
        "autogroup:nonroot"
        "root"
      ];
    }
  ];
}
