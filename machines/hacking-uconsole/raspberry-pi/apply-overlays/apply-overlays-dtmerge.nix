paramsPerOverlayMap: {
  lib,
  stdenvNoCC,
  dtc,
  libraspberrypi,
}:
with lib; (base: overlays':
    stdenvNoCC.mkDerivation {
      name = "device-tree-overlays";
      nativeBuildInputs = [dtc libraspberrypi];
      buildCommand = let
        overlays = toList overlays';
        baseDTBs =
          map (x: (builtins.unsafeDiscardStringContext (lib.removeSuffix ".dtb" (builtins.baseNameOf x))))
          (lib.filesystem.listFilesRecursive "${base}");
      in ''
        mkdir -p $out
        cd "${base}"
        find . -type f -name '*.dtb' -print0 \
          | xargs -0 cp -v --no-preserve=mode --target-directory "$out" --parents

        echo baseDTBs: ${toString baseDTBs}

        ${flip (concatMapStringsSep "\n") baseDTBs (o: ''
          dtb=$(find "$out" -type f -name '${o}.dtb')
          echo -n "Applying params to ${o}.dtb... "
          echo -n ${concatStringsSep " " (mapAttrsToList (name: value: "${name}=${value}") (paramsPerOverlayMap.${o} or {}))} " "
          mv "$dtb"{,.in}
          dtmerge "$dtb.in" "$dtb" - ${concatStringsSep " " (mapAttrsToList (name: value: "${name}=${value}") (paramsPerOverlayMap.${o} or {}))}
          rm "$dtb.in"
          echo "ok"
        '')}

        for dtb in $(find "$out" -type f -name '*.dtb'); do
          dtbCompat=$(fdtget -t s "$dtb" / compatible 2>/dev/null || true)
          # skip files without `compatible` string
          test -z "$dtbCompat" && continue

          ${flip (concatMapStringsSep "\n") overlays (o: ''
          overlayCompat="$(fdtget -t s "${o.dtboFile}" / compatible)"

          # skip incompatible and non-matching overlays
          if [[ ! "$dtbCompat" =~ "$overlayCompat" ]]; then
            echo "Skipping overlay ${o.name}: incompatible with $(basename "$dtb")"
          elif ${
            if ((o.filter or null) == null)
            then "false"
            else ''
              [[ "''${dtb//${o.filter}/}" ==  "$dtb" ]]
            ''
          }
          then
            echo "Skipping overlay ${o.name}: filter does not match $(basename "$dtb")"
          else
            echo -n "Applying overlay ${o.name} to $(basename "$dtb")... "
            mv "$dtb"{,.in}

            # dtmerge requires a .dtbo ext for dtbo files, otherwise it adds it to the given file implicitly
            dtboWithExt="$TMPDIR/$(basename "${o.dtboFile}").dtbo"
            cp -r ${o.dtboFile} "$dtboWithExt"

            echo -n ${concatStringsSep " " (mapAttrsToList (name: value: "${name}=${value}") (paramsPerOverlayMap.${o.name} or {}))} " "
            dtmerge "$dtb.in" "$dtb" "$dtboWithExt" ${concatStringsSep " " (mapAttrsToList (name: value: "${name}=${value}") (paramsPerOverlayMap.${o.name} or {}))}

            echo "ok"
            rm "$dtb.in" "$dtboWithExt"
          fi
        '')}
        done
      '';
    })
