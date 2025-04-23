{
  description = "A development environment with c-hello";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    c-hello.url = "github:brucechanjianle/nix-c-hello";
  };

  outputs = { self, nixpkgs, c-hello }:
  let
    # System types to support
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    # Helper function to generate an attrset
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in
  {
    # Setup development shell
    devShells = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = pkgs.mkShell {
          buildInputs = [
            c-hello.packages.${system}.default
          ];
        };
      }
    );
  };
}
