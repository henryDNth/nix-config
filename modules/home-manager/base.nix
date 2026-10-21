{
  flake.modules.homeManager.base =
    { params, ... }:
    {
      home = {
        username = params.user.name;
        homeDirectory = "/home/${params.user.name}";
      };
      programs.home-manager.enable = true;
      # HM release-26.05 builds options.json with context-less references to
      # nixpkgs (assertions.nix/meta.nix declarations), which triggers an eval
      # warning. Fixed on HM master; drop this once it's backported.
      manual.manpages.enable = false;
    };
}
