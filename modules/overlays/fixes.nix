{ ... }:
{
  flake.overlays.fixes = final: prev: {
    # temporary workaround until upstream fix: https://nixpk.gs/pr-tracker.html?pr=534770
    openblas = prev.openblas.overrideAttrs {
      doCheck = prev.stdenv.hostPlatform.system != "i686-linux";
    };
  };
}
