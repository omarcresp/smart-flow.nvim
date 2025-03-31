{
  description = "A Neovim plugin for Smart Flow with autosave functionality";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      flake = {
        overlays.default = final: prev: {
          vimPlugins = prev.vimPlugins // {
            smart-flow-nvim = inputs.self;
          };
        };
      };

      perSystem = { pkgs, system, ... }:
        let
          smart-flow = pkgs.vimUtils.buildVimPlugin {
            pname = "smart-flow";
            version = "dev";
            src = inputs.self;
            meta = {
              homepage = "https://github.com/omarcresp/smart-flow.nvim";
              license = pkgs.lib.licenses.mit;
              maintainers = [];
              description = "A Neovim plugin for Smart Flow with autosave functionality when leaving insert mode";
            };
          };

          neovimWithPlugin = pkgs.neovim.override {
            configure = {
              packages.myPlugins = {
                start = [ smart-flow ];
              };
              customRC = ''
                lua << EOF
                require('smart-flow').setup({
                  debug = true,
                  autosave = true,
                })
                EOF
              '';
            };
          };
        in
        {
          packages = {
            default = smart-flow;
            smart-flow = smart-flow;
          };

          legacyPackages.defaultPackage = smart-flow;

          checks.build = smart-flow;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              neovim
              stylua
              git
            ];
          };

          apps = {
            format = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "format" ''
                  set -euo pipefail
                  cd "$(${pkgs.git}/bin/git rev-parse --show-toplevel)"
                  ${pkgs.stylua}/bin/stylua --config-path stylua.toml lua/
                ''
              );
            };

            default = {
              type = "app";
              program = "${neovimWithPlugin}/bin/nvim";
            };
          };

          formatter = pkgs.stylua;
        };
    };
} 
