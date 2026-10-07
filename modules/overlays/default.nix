# This file defines overlays
{ inputs, lib, ... }:
{
  flake.overlays.default = lib.composeManyExtensions [
    inputs.self.overlays.mudita
  ];
}
