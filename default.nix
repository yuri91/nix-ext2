{ lib
, runCommand
, writeReferencesToFile
, e2fsprogs
}:
let
  ext2 = drv:
    let closure = writeReferencesToFile drv;
    in
    runCommand "ext2-bundle" { buildInputs = [ e2fsprogs ]; } ''
      set -o pipefail
      tmp=$(mktemp -d)
      ln -s ${drv}/* $tmp/
      xargs tar c < ${closure} | tar -xC $tmp/
      size=($(du -sh $tmp))
      mkfs.ext2 -r 0 -d $tmp $out ''${size[0]}
    '';
in
{ }
