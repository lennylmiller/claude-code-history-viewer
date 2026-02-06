{
  description = "Claude Code History Viewer - Tauri desktop app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Core runtimes
              nodejs_20
              pnpm

              # Rust toolchain (includes cargo, rustc, rustfmt, clippy)
              cargo
              rustc
              rustfmt
              clippy

              # Build tools
              just
              pkg-config

              # Cargo development tools
              cargo-nextest
              cargo-llvm-cov
              cargo-watch
              cargo-audit
              cargo-insta

            ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              # Linux-only: Tauri system dependencies
              gtk3
              webkitgtk_4_1
              libappindicator-gtk3
              librsvg
              patchelf
            ];

            shellHook = ''
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo "Claude Code History Viewer - Development Environment"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo "Node.js:  $(node --version)"
              echo "pnpm:     $(pnpm --version)"
              echo "Rust:     $(rustc --version | cut -d' ' -f2)"
              echo "Cargo:    $(cargo --version | cut -d' ' -f2)"
              echo "just:     $(just --version | cut -d' ' -f2)"
              echo ""
              echo "Commands:"
              echo "  just setup       # Install dependencies"
              echo "  just dev         # Start development server"
              echo "  just test        # Run tests"
              echo "  just            # List all commands"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            '';
          };
        }
      );
    };
}
