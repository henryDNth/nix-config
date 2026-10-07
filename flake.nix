{
  description = "Henry's NixOS, nix-darwin and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # base hardware configs to easily inherit from
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    import-tree.url = "github:vic/import-tree";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };
  outputs =
    inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
      debug = true;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Needed for external coonsumption.
      flake.flakeModules.default = (inputs.import-tree ./modules);
      flake.overlays.default = inputs.nixpkgs.lib.composeManyExtensions [
        inputs.self.overlays.mudita
        inputs.self.overlays.fixes
      ];

      imports = [
        flake.flakeModules.default
      ];

      _module.args.rootPath = ./.;
    };
}
