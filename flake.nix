{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      make-ext2 = pkgs.callPackage ./make-ext2.nix {};
      my-env = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [
          hello
          bashInteractive
        ];
        pathsToLink = [
          "/bin"
        ];
      };
      # this is in KB
      free-space = 10*1024;
    in
    {
      defaultPackage = make-ext2 my-env free-space;
    }
  );
}
