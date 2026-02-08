# Repository Guidelines

## Project Structure & Module Organization
- `src/` is the React + TypeScript frontend (components, hooks, services, store, utilities).
- `src/test/` holds frontend test helpers and test files.
- `src-tauri/` is the Rust backend for Tauri, with `src/` code, `tests/`, and `benches/`.
- `public/` stores static assets for Vite.
- `scripts/` contains i18n tooling.
- `docs/` and `README*.md` cover documentation and releases.

## Build, Test, and Development Commands
Use `pnpm` as the package manager.
- `just dev` runs the Vite dev server with hot reload.
- `just tauri-build` builds the production desktop app.
- `just lint` runs ESLint against `src/`.
- `just test` runs Vitest in watch mode; `just test-run` runs once with verbose output.
- `just rust-test` runs Rust tests single-threaded (required by this codebase).
- `just rust-lint` runs `cargo clippy` with warnings as errors.

If you don’t use `just`, check `package.json` and `CLAUDE.md` for equivalents like `pnpm test`.

## Architecture Overview
- The UI is a Vite-powered React app in `src/`, with state in `src/store/` and data access in `src/services/`.
- The desktop shell and backend are in `src-tauri/`, exposing commands used by the frontend via Tauri APIs.
- Runtime data is read from `~/.claude` locally; no network services are required.

## Coding Style & Naming Conventions
- TypeScript/React: follow existing patterns in `src/`. Use descriptive names (e.g., `SessionBoard.tsx`, `useSearch.ts`).
- Linting: ESLint is the primary guardrail (`just lint`).
- Rust: format with `rustfmt` and lint with `clippy` (`just rust-lint`).
- Favor explicit, readable code over clever abstractions.

## Testing Guidelines
- Frontend: Vitest + React Testing Library (`pnpm test` or `just test`).
- Backend: Rust unit/integration tests in `src-tauri/src` and `src-tauri/tests`.
- Rust tests must run single-threaded: `cargo test -- --test-threads=1` (enforced by `just rust-test`).
- Add or update tests alongside code changes.

## Commit & Pull Request Guidelines
- Commit messages follow Conventional Commits: `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, with optional scopes like `fix(rust): ...`.
- Before opening a PR, run `pnpm tsc --build .`, `pnpm vitest run`, `pnpm lint`, and `cd src-tauri && cargo test -- --test-threads=1`.
- PRs should include a clear summary, testing notes, and screenshots for UI changes.

## Configuration Notes
- The app reads conversation data from `~/.claude` at runtime. Keep changes compatible with this layout.
- Versioning is driven by `package.json`; run `just sync-version` after bumping.
