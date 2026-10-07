{
  flake.modules.nixos.base = {
    boot.kernel.sysctl."kernel.dmesg_restrict" = false;
    security.polkit.enable = true;
  };
}
