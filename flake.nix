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

      src = pkgs.fetchFromGitHub {
        owner = "adi1090x";
        repo = "rofi";
        rev = "7ba824d4915535816bd652c13d25f3326ae6c381";
        hash = "sha256-IPtn0bDIUmSwm24YowURgNrs907RrcfrRM9TdhE2c0I=";
      };

      buildPhase = ''
        chmod +x setup.sh
      '';

      installPhase = ''
        mkdir -p $out/bin
        mv setup.sh $out/bin/rofi-extended
        mv files $out/bin
        mv fonts $out/bin
      '';
    };
  });
}
