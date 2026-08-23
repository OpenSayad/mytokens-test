# Architecture and operations notes

## Runtime path

The CLI entrypoint in `src/index.ts` parses Commander options and selects a render screen or export command. `src/app.ts` runs the source adapters concurrently. Adapters parse local coding-assistant records into a shared `UsageDataMessage` shape containing source, agent, date, model/provider, token counts, and optional project data.

The OpenCode adapter first opens `~/.local/share/opencode/opencode.db` read-only and queries `message` joined to `session`. It selects assistant messages whose JSON data contains tokens, then falls back to legacy JSON message files if the database is unavailable or empty. Other adapters inspect source-specific JSONL, JSON, CSV, and text files in the user's home directory. Missing files are tolerated, so a source can contribute no messages without stopping parsing.

After filtering, overview rendering loads model metadata and pricing from `https://models.dev/api.json`. A failed HTTP response throws from the cached fetch layer; pricing is used for input, output, reasoning, and cache cost estimates. Parsed files and remote responses are cached below `~/.mytokens/cache`; cache controls are exposed through `--fresh`, `--no-cache`, and the `cache` subcommands.

## Boundaries and outputs

The program reads local files and the OpenCode SQLite database, calls the models.dev HTTPS endpoint, and writes local cache/report files. Dashboard screens print token and cost tables to stdout. The `export` command writes SVG or PNG. The `image` command requires a TTY and can request clipboard integration on macOS.

## Build, test, and release

- `pnpm typecheck` runs TypeScript checking without emitting files.
- `pnpm lint` runs ESLint; `pnpm lint:fix` applies fixes.
- `pnpm test` runs the Vitest suite once; `pnpm test:watch` watches tests.
- `pnpm build` runs tsdown using `tsdown.config.ts` and produces the package entry at `dist/index.js` as declared by `package.json`.
- The GitHub Actions publish workflow installs dependencies from `pnpm-lock.yaml`, builds, publishes to npm, and pushes the version commit on a published release.
- UiGraph workflows validate and sync `.uigraph.yaml` and `.uigraph/**`; the artifact workflow can open an update pull request after pushes to `main`.

The repository contains Vitest coverage for parsing, date filtering, caching, model grouping, SVG/overview rendering, and multiple source adapters. Those are project tests; no separate UiGraph test pack is declared because the repository has no HTTP API or user-facing service endpoint contract.
