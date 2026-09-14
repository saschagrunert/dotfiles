_: {
  programs = {
    bcc.enable = true;
    fish = {
      enable = true;
      # Translate the bash shell init to fish at build time instead of running
      # bash through foreign-env on every shell start
      useBabelfish = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    direnv = {
      enable = true;
      silent = true;
      # The direnv package already hooks fish through vendor_conf.d
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
    mtr.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
