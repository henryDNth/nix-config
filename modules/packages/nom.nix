{ ... }:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.nix-output-monitor = pkgs.nix-output-monitor;
    };
}
