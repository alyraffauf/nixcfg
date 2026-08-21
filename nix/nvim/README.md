# Neovim

This flake builds one standalone nvf package. It does not use Home Manager.

| Package  | Module                  | Command      | State directory             |
| -------- | ----------------------- | ------------ | --------------------------- |
| `.#nvim` | `neovimModules.default` | `hoenn-nvim` | `~/.local/state/hoenn-nvim` |

Run the package through the flake:

```sh
nix run .#nvim
```

Another nvf configuration can import a module directly:

```nix
inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [inputs.hoenn.neovimModules.default];
}
```

## Source layout

The profile follows the repository's dendritic module layout. `profile.nix` names the application. `keybindings/default.nix` defines the shared leader vocabulary and window movement keys, while `keybindings/config.lua` installs the mappings.

Each entry under `features/` owns one removable behavior. A Nix-only feature stays in one file. A feature with Lua gets a directory containing `default.nix` and `config.lua`. For example, `features/autosave/default.nix` loads `features/autosave/config.lua`. There are no shared UI, editing, navigation, or tooling modules.

Directories under `languages/` own one language end to end. Each module supplies that language's executables, formatter order, parser, plugins, and Lua setup. For example, `languages/python/default.nix` contains the Python packages, formatter order, Treesitter parser, and debugpy plugin. `languages/python/config.lua` contains its LSP and debugger configuration.

## Clean profile behavior

The clean profile changes the process working directory to the closest project root. It checks Git plus markers for Nix, Go, Rust, Python, JavaScript, Gleam, Ansible, Docker, and Make projects. A file outside a marked project uses its parent directory.

Autosave runs after insert mode, idle time, buffer changes, and focus loss. It only writes named, writable, ordinary file buffers. Read-only buffers, special buffers, unnamed buffers, and large files stay untouched. A large file means more than 1 MiB or 20,000 lines. Large-file mode also turns off syntax parsing, folds, completion, undo files, and format-on-save for that buffer.

Conform runs external formatters first. It asks an LSP client to format only when the filetype has no configured external formatter. `:FormatToggle` controls format-on-save for the whole process. `:FormatToggleBuffer` controls the current buffer. The matching keys are `<leader>cf` and `<leader>cF`.

When Neovim starts without file arguments, resession loads the session keyed by the current project root. Neovim saves that project session on exit when at least one ordinary file buffer exists. Neo-tree opens on the left after session loading, unless the restored layout already contains a tree window. Starting with file arguments skips session loading.

JavaScript and TypeScript projects use VTSLS. An ESLint configuration starts the ESLint language server and linter. Without one, Oxlint handles diagnostics. Tailwind starts only when the project has a Tailwind configuration or lists `tailwindcss` in `package.json`.

## Keys

`<C-p>` opens the command picker. Direct `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` mappings move between Neovim windows. They do not call tmux.

The main leader groups are:

- `<leader>b` for open-buffer actions
- `<leader>c` for code behavior such as format-on-save
- `<leader>d` for debugger commands
- `<leader>f` for files, grep, buffers, symbols, recent files, and commands
- `<leader>g` for Git pickers, Diffview, and lazygit
- `<leader>p` for project-wide operations
- `<leader>q` for the root-keyed session
- `<leader>t` for terminals
- `<leader>v` for view controls such as the outline and minimap
- `<leader>x` for Trouble problem lists

Neo-tree uses filesystem, open-buffer, and Git views. It shows dotfiles and hides Git-ignored files. `<leader>e` toggles it. The minimap stays closed until `<leader>vm` opens it.

## Markdown images

The image plugin configures its Kitty backend only when the environment reports Kitty or WezTerm support. In that case it downloads and renders every visible local or remote Markdown image. Other terminals load Markdown without image setup or network requests.
