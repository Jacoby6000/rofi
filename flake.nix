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
        mkdir $out/bin

        create_symlinks() {
          local dir=$1
          local prefix=$2
          for sub_dir in $out/$dir/*; do

            # convert _ to - in sub_dir
            sub_dir_name=$(basename $sub_dir)
            script_output_name=$(echo $sub_dir_name | tr '_' '-')
            
            # Produces output bin with name rofi-$(prefix)-$(type-n)
            ln -s $sub_dir/$dir.sh $out/bin/rofi-$prefix-$script_output_name
          done
        }

        create_symlinks "launchers" "launcher"
        create_symlinks "powermenu" "powermenu"
        
        # Symlink applets to $out/bin with the name rofi-applet-$scriptName, without .sh suffix
        for applet in $out/applets/bin/*.sh; do
          applet_name=$(basename $applet .sh)
          ln -s $out/$applet $out/bin/rofi-applet-$applet_name
        done
      '';
    };
  });
}
