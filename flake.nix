{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "minifb";
            version = "1.0.0";
            src = ./.;
            nativeBuildInputs = with pkgs; [cmake];
            cmakeFlags = pkgs.lib.optionals pkgs.stdenv.isDarwin [
              "-DMINIFB_USE_METAL_API=ON"
              "-DBUILD_SHARED_LIBS=ON"
            ];
          };
        };
      }
    );
}
