# dotnix

Using nix to provisioning devices on Mac OSX (M-series chip). Inspect `apps.json` for the default set of apps / packages will be installed.

System packages also installed.

- fish [Fish shell](https://fishshell.com)
- zsh
- Fonts: `hack-font`, `fira-code`, `open-sans`, `source-code-pro`, `jetbrains-mono`

Following are extra that will be added on to current-user scope:

- `direnv` / `git` / `ssh` (link to 1P) / `gpg`
- `vscode`
- [`exa`](https://the.exa.website)
- [`fzf`](https://github.com/junegunn/fzf)
- [`zoxide`](https://github.com/ajeetdsouza/zoxide)
- [`gh-cli`](https://cli.github.com) with extensions
  - [`gh-eco`](https://github.com/jrnxf/gh-eco)
  - [`gh-dash`](https://github.com/dlvhdr/gh-dash)
  - [`gh-markdown-preview`](https://github.com/yusukebe/gh-markdown-preview)

As mentioned, fish and zsh shells are available (asides from system provided shells).

- Fish shell extensions:
  - [`hydro theme`](https://github.com/jorgebucaran/hydro)
  - `grc`
  - [`colored-man-pages`](https://github.com/PatrickF1/colored_man_pages.fish)
  - `foreign-env`
  - [`sponge`](https://github.com/meaningful-ooo/sponge)
  - [`forgit`](https://github.com/wfxr/forgit)
  - [`pisces`](https://github.com/laughedelic/pisces)
  - [`puffer`](https://github.com/nickeb96/puffer-fish)
  - [`humantime-fish`](https://github.com/jorgebucaran/humantime.fish)
  - [`done`](https://github.com/franciscolourenco/done)
  - [`bass`](https://github.com/edc/bass)
  - [`github-copilot-cli`](https://github.com/z11i/github-copilot-cli.fish)

- Zsh shell extensions are (managed via [`zimfw`](https://zimfw.sh))
  - [`pure theme`](https://github.com/sindresorhus/pure)
  - [`environment`](https://github.com/zimfw/environment)
  - [`git`](https://github.com/zimfw/git)
  - [`input`](https://github.com/zimfw/input)
  - [`termtitle`](https://github.com/zimfw/termtitle)
  - [`utility`](https://github.com/zimfw/utility)
  - [`duration-info`](https://github.com/zimfw/duration-info)
  - [`git-info`](https://github.com/zimfw/git-info)
  - [`prompt-pwd`](https://github.com/zimfw/prompt-pwd)
  - [`archive`](https://github.com/zimfw/archive)

## 🏗️ Install Requirements

  1. Install [brew](https://brew.sh)

  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

  2. Install nix (as multi-user) [nix-installer](https://github.com/DeterminateSystems/nix-installer)

  ```sh
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```

  3. Clone this repo to `~/.setup`

Notes:

- If `/etc/nix/nix.conf` already existed, move it to `~/.config/nix/nix.conf`
- If `/etc/shells` already existed, back up and remove
- If running into error `...ln: failed to create symbolic link '/run': Read-only file system`

  ```sh
  sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
  ```

- if running to warning `warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring`

  ```sh
  sudo cp -R /nix/var/nix/profiles/per-user/<username>/channels /nix/var/nix/profiles/per-user/root/
  ```

## 🗂️ Setup configurations

- Setup a public/private repo `github:<username>/dotnix-config` (see [Example](https://github.com/nigelng/dotnix-config-example)).

- Update `mahConfig.url` in `flake.nix` to the above repo url

  ```nix
  {
    mahConfig.url = "git+ssh://git@github.com/nigelng/dotnix-config?ref=main";
  }
  ```

- On WSL, ensure `~/.config/nix/nix.conf` is available with content

  ```conf
  # nix/nix.conf
  experimental-features = nix-command flakes
  ```

- Commit

## 🏃 Run the specific script

### Mac OS

```sh
darwin-rebuild switch --flake .
```

### WSL

```sh
nix build .#homeConfigurations.<hostname>.activationPackage # product a result folder
./result/activate
```

## 🤡 Caveats

- Only brews / casks that specified in `./config/apps.json` will be installed. Non specified will be removed
- Mas refers to `Mac App Store` apps will be installed as extra. Existing Mas id can located via [mas-cli](https://github.com/mas-cli/mas)
- [Trusted uses](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-trusted-users) will be current user plus all specified in `system.json`. Default: `[<username>]`
- [Allowed users](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-allowed-users) will be current user plus all specified in config. Default: `[*]`
- By default, git will required [GPG setup](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) to [sign commits](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work). `include` and `includeIf` are available for multiple git profiles. See `git.example` for details. Remove if not required.
- On MacOSX, reset current-user shell to

  ```sh
    # fish
    chsh -s /run/current-system/sw/bin/fish

    # zsh
    chsh -s /run/current-system/sw/bin/fish
  ```

- On WSL, `fish` is not working due to missing `$PATH`
