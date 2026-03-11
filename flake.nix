{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
    sandbox = false;
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { ... }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            deno = {
              enable = true;
            };
            nixpkgs-fmt.enable = true;
          };
        };

        devenv.shells.default = {
          files."deno.json".json = {
            # fmt.options.indentWidth = 4;
            lint.rules.exclude = [
              "no-sloppy-imports"
            ];
          };

          # git-hooks.hooks.denolint.enable = true;

          languages = {
            typescript.enable = true;
            javascript = {
              enable = true;
              bun = {
                enable = true;
                install.enable = true;
              };
            };
          };
        };
      };
    };
}
