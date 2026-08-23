# Mytokens CLI usage reference

`mytokens` is a Node.js 18+ command-line program. It reads locally stored coding-assistant usage records, normalizes token data, obtains model metadata and pricing from `https://models.dev/api.json`, and renders usage and estimated-cost reports.

## Installation and commands

- `npx mytokens` runs the default `models-by-tokens` screen.
- `npm i -g mytokens` installs the `mytokens` executable globally.
- `mytokens [screen]` selects a screen positionally.
- `mytokens --screen <screen>` or `--display <screen>` selects a screen; without a value the CLI opens an interactive picker.
- `mytokens export` writes an aggregated overview, defaulting to `mytokens.svg`.
- `mytokens image` renders the aggregated overview in a TTY; `--copy` requests macOS clipboard copy.
- `mytokens themes` lists export themes.
- `mytokens cache clear|ls|size` manages the local parse cache.

Available screen families are `models`, `sources`, `projects`, `providers`, `agents`, and `type`, each with `-by-tokens` or `-by-costs` variants. Time grouping supports `--by day|week|month|year` and the shorthand flags `--day`, `--week`, `--month`, and `--year`.

## Filters and defaults

The dashboard defaults to the last 30 days. `--all` removes that default. Date selection supports `--from YYYY-MM-DD`, `--to YYYY-MM-DD`, `--today`, `--yesterday`, `--last-week`, `--last-month`, `--last-year`, `--this-week`, `--this-month`, `--this-year`, and `--last <positive-days>`.

Comma-separated include/exclude filters are available for `--sources`, `--skip-sources`, `--agents`, `--skip-agents`, `--models`, `--skip-models`, `--projects`, `--skip-projects`, `--providers`, and `--skip-providers`. `--fresh` bypasses parser caches; `--no-cache` refetches remote model data; `--no-group` and `--no-auto-group` control model grouping.

Export additionally accepts `--output <path>`, `--format svg|png`, `--scale <positive-number>` for PNG, `--theme <theme>`, and `--projects <non-negative-count>`.

## Inputs and outputs

The OpenCode adapter reads `~/.local/share/opencode/opencode.db` read-only, with a legacy fallback at `~/.local/share/opencode/storage/message/*.json`. Other adapters read source-specific files under the user home directory, including JSONL, JSON, and CSV usage logs for tools such as Codex, Claude, and Cursor. The implemented adapters use these source-specific paths; the README's first-argument and `OPENCODE_DB_PATH` claims are not implemented in the inspected source.

The program writes cache data under `~/.mytokens/cache`, including `registry.json` and `parse-cache-v1.json`. `export` writes SVG or PNG to the requested local path. Normal terminal commands write tables and warnings to stdout.
