{ ... }:
{
  flake.overlays.fixes = final: prev: {
    # temporary workaround until upstream fix: https://nixpk.gs/pr-tracker.html?pr=534770
    openblas = prev.openblas.overrideAttrs {
      doCheck = prev.stdenv.hostPlatform.system != "i686-linux";
    };
    # Upstream fix is still open: https://github.com/maralorn/nix-output-monitor/pull/321
    nix-output-monitor = prev.nix-output-monitor.override {
      extraComposeFunctions = [
        (final.haskell.lib.compose.appendPatch ./patches/nix-output-monitor-unknown-types.patch)
      ];
    };
  };
}
