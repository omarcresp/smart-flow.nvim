<p align="center">
  <h1 align="center">smart-flow.nvim</h2>
</p>

<p align="center">
    > A catch phrase that describes your plugin.
</p>

<div align="center">
    > Drag your video (<10MB) here to host it for free on GitHub.
</div>

<div align="center">

> Videos don't work on GitHub mobile, so a GIF alternative can help users.

_[GIF version of the showcase video for mobile users](SHOWCASE_GIF_LINK)_

</div>

## ⚡️ Features

> Write short sentences describing your plugin features

- FEATURE 1
- FEATURE ..
- FEATURE N
- Autosave when leaving insert mode - automatically saves your buffer when exiting insert mode with 5-second debounce
- Autosave after undo/redo operations - ensures your changes are saved after undoing or redoing work

## 📋 Installation

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>Snippet</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

</td>
<td>

```lua
-- stable version
use {"smart-flow.nvim", tag = "*" }
-- dev version
use {"smart-flow.nvim"}
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
-- stable version
Plug "smart-flow.nvim", { "tag": "*" }
-- dev version
Plug "smart-flow.nvim"
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
-- stable version
require("lazy").setup({{"smart-flow.nvim", version = "*"}})
-- dev version
require("lazy").setup({"smart-flow.nvim"})
```

</td>
</tr>
<tr>
<td>

[NixOS/Nix](https://nixos.org/)

</td>
<td>

```nix
# In your flake.nix
{
  inputs = {
    # ...
    smart-flow-nvim.url = "github:omarcresp/smart-flow.nvim";
  };

  outputs = { self, nixpkgs, smart-flow-nvim, ... }: {
    # For NixOS configuration
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        # ...
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ smart-flow-nvim.overlay ];
          programs.neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [
              # ...
              smart-flow-nvim
            ];
          };
        })
      ];
    };

    # Or for home-manager
    homeConfigurations.yourusername = home-manager.lib.homeManagerConfiguration {
      # ...
      modules = [
        # ...
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ smart-flow-nvim.overlay ];
          programs.neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [
              # ...
              smart-flow-nvim
            ];
          };
        })
      ];
    };
  };
}
```

</td>
</tr>
</tbody>
</table>
</div>

## ☄ Getting started

> Describe how to use the plugin the simplest way

## ⚙ Configuration

> The configuration list sometimes become cumbersome, making it folded by default reduce the noise of the README file.

<details>
<summary>Click to unfold the full list of options with their default values</summary>

> **Note**: The options are also available in Neovim by calling `:h smart-flow.options`

```lua
require("smart-flow").setup({
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
    -- Automatically save when leaving insert mode
    autosave = false,
    -- Debounce time in milliseconds for autosave (default: 5 seconds)
    debounce_time = 5000,
})
```

</details>

## 🧰 Commands

|   Command      |         Description        |
|----------------|----------------------------|
|  `:SmartFlow`  |     Enables the plugin.    |

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

### Development with Nix

If you have Nix installed with flakes enabled, you can use the following commands:

- `nix develop` - Enter a development shell with all required dependencies
- `nix run .#format` - Format all Lua files in the project using stylua
- `nix run` - Launch Neovim with the smart-flow plugin preinstalled and enabled

## 🗞 Wiki

You can find guides and showcase of the plugin on [the Wiki](https://github.com/omarcresp/smart-flow.nvim/wiki)

## 🎭 Motivations

> If alternatives of your plugin exist, you can provide some pros/cons of using yours over the others.
