{ lib, inputs, ... }:
{
  flake.overlays.default = lib.composeManyExtensions [
    inputs.self.overlays.mudita
    inputs.self.overlays.fixes
    inputs.curseforge.overlays.default
  ];
}
