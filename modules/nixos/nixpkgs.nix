{
  withSystem,
  inputs,
  rootPath,
  ...
}:
{
  imports = [
    # This import ensures the same nixpkgs are used for nixos, devshells, and packages
    # https://flake.parts/system#approach-2-configure-pkgs-once-in-persystem
    inputs.nixpkgs.nixosModules.readOnlyPkgs
  ];

  config = {
    # Modify nixpkgs once for each system.
    # https://flake.parts/system#approach-2-configure-pkgs-once-in-persystem
    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.self.overlays.default
            # Don't want to have to add this input to downstream work config
            (if inputs ? curseforge then inputs.curseforge.overlays.default else { })
          ];
          config = {
            allowUnfree = true;
          };
        };
      };

    # Use the configured pkgs from perSystem
    flake.modules.nixos.base =
      { system, ... }:
      {
        nixpkgs.pkgs = withSystem system (
          { pkgs, ... }: # perSystem module arguments
          pkgs
        );
      };
  };
}
