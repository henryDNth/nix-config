{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = [
        (if pkgs ? curseforge then pkgs.curseforge else null)
      ];
    };
}
