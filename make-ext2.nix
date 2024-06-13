{ lib
, runCommand
, writeReferencesToFile
, e2fsprogs
}:
drv: extra-size:
let closure = writeReferencesToFile drv;
in
runCommand "ext2-bundle" { buildInputs = [ e2fsprogs ]; } ''
  set -o pipefail
  tmp=$(mktemp -d)
  # symlink drv into the root
  ln -s ${drv}/* $tmp/
  # copy dependencies, including drv itself
  xargs tar c < ${closure} | tar -xC $tmp/
  size=($(du -s -B 1024 $tmp))
  total_size=$((size[0] + ${toString extra-size}))
  # make image
  mkfs.ext2 -r 0 -d $tmp $out $total_size
''
