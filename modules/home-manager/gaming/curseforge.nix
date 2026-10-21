{
  flake.modules.homeManager.gaming =
    { pkgs, lib, ... }:
    {
      home.packages = [

      ]
      ++ lib.optionals (pkgs ? curseforge) [ pkgs.curseforge ];
    };
}
