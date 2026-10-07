{ rootPath, ... }:
{
  flake.overlays.mudita = final: prev: {
    mudita = final.callPackage "${rootPath}/packages/mudita" { };
  };
}
