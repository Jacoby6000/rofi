{
  description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { 
    self, 
    nixpkgs, 
    flake-utils,
    ... 
  }:
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.default = pkgs.stdenv.mkDerivation {
      name = "rofi-extended";
      version = "2024-06-29";

      src = ./.;

      buildPhase = ''
        patchShebangs .
        chmod +x setup.sh
      '';

      installPhase = ''
        ./setup.sh $out $out/share/fonts/ttf
      '';
    };
  });
}
