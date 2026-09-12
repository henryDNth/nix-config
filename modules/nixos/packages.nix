{
  perSystem = { config, pkgs, ... }: {
    packages = {
      mudita = pkgs.mudita;
      default = config.packages.mudita;
    };
  };
}
