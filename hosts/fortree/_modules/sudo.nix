_: {
  security = {
    pam.services.sudo_local = {
      reattach = true;
      touchIdAuth = true;
      watchIdAuth = true;
    };

    sudo.extraConfig = ''
      root ALL=(ALL) NOPASSWD: ALL
      %admin ALL=(ALL) NOPASSWD: ALL
    '';
  };
}
