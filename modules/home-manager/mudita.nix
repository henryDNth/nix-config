{
  flake.modules.homeManager.extras =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        mudita
      ];
    };
}
