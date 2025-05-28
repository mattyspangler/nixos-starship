{
  config,
  lib,
  ...
}:
with lib; let
  overlayParamsType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Name of an overlay for which params are going to be passed to dtmerge.
        '';
      };

      params = mkOption {
        type = types.attrsOf types.str;
        description = lib.mdDoc ''
          Params to pass to dtmerge.
        '';
      };
    };
  };

  paramsPerOverlayMap =
    builtins.mapAttrs
    (_: value: builtins.foldl' (a: b: a // b) {} (builtins.catAttrs "params" value))
    (builtins.groupBy (x: x.name) config.hardware.deviceTree.overlaysParams);

  dtmergeOverlay = _final: prev: {
    deviceTree =
      prev.deviceTree
      // {
        applyOverlays = _final.callPackage ((import ./apply-overlays-dtmerge.nix) paramsPerOverlayMap) {};
      };
  };
in {
  options = {
    hardware.deviceTree.overlaysParams = mkOption {
      default = [];
      type = types.listOf overlayParamsType;
    };
  };

  config = {
    nixpkgs.overlays = [
      dtmergeOverlay
    ];
  };
}
