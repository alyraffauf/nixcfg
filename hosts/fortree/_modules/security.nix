_: {
  security = {
    pam.services.sudo_local.touchIdAuth = true;

    sudo.extraConfig = ''
      root ALL=(ALL) NOPASSWD: ALL
      %admin ALL=(ALL) NOPASSWD: ALL
    '';
  };
}
