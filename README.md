# godot-server.nvim

This project aims to integrate the Godot editor and Neovim. It contains 2 components:

- A script to launch Neovim from Godot
- An optional (but recommended) Neovim plugin to connect Godot to previously running Neovim instances

**Features:**

- **Open files** from Godot into Neovim automatically
- **Step-by-step** setup instructions
- Supports launching Neovim from Godot or from terminal

## How It Works

To connect the Godot editor and Neovim, we must start a Neovim server which Godot can send "open file" commands to. This can be done with the `--listen` Neovim option, or with `vim.fn.serverstart` within Neovim. We configure Godot to run a script which launches Neovim if it's not running, or connects to an previously launched instance of Neovim.

The [launch script](./godot-nvim.sh) does exactly this. When opening a file from Godot configured to run the script, it will check a Neovim server is running for the current project. If it is, it will open the file inside that instance of Neovim. If no Neovim servers is running for the project, it will launch Neovim in a new terminal window and open the file.

With the optional Neovim plugin, opening a Godot project inside Neovim will automatically start the server as well.

## Godot Launch Script Setup

The script is required for Godot to open files in Neovim

1. Download the [launch script](./godot-neovim.sh) to your computer.
   I recommend placing it in `~/.config/godot`. You can do this automatically with: `curl -o ~/.config/godot/godot-neovim.sh https://raw.githubusercontent.com/Cretezy/godot-server.nvim/refs/heads/main/godot-neovim.sh`
   Make sure the script is executable as well: `chmod +x ~/.config/godot/godot-neovim.sh`
1. Modify the downloaded script's `$term_exec` parameter to point to your terminal emulator. If your terminal emulator requires parameters, add them in the `start_server` function.
   You may also opt to set this to an empty string if you will only be pre-launching Neovim from your terminal using the plugin.
1. Open Godot's editor settings under `Editor -> Editor Settings` and go to `Text Editor -> External`.
1. Enable `Advanced Settings` in the top right of the window.
1. Enable `Use External Editor`.
1. Set `Exec Path` to the full path of your downloaded (and executable) launch script path, e.g. `/home/$USER/.config/godot/godot-neovim.sh` (replace `$USER` with your username).
   You can use the file browser (file icon to the right of the text input) to get the full path.
1. Set `Exec Flags` to: `"{file}" "{line},{col}"`

<details>
   <summary>Step-by-step with images</summary>

   1. Download the [launch script](./godot-neovim.sh) to your computer.
   ![image](https://github.com/user-attachments/assets/1436da2f-95b3-488f-8e92-fc8eb5e7ac83)

1. Modify the downloaded script's `$term_exec`
   ![image](https://github.com/user-attachments/assets/7c4b2683-bb62-4167-986f-953f4c8b35c2)
   ![image](https://github.com/user-attachments/assets/4d801358-d5fa-4662-8aa9-d31ecac4e9da)

1. Open Godot's text editor settings and configure editor
   ![image](https://github.com/user-attachments/assets/d66d4179-3515-432d-8c33-46c188751b75)
   ![image](https://github.com/user-attachments/assets/136a82b2-336b-405e-b2fc-26dc15231009)

</details>

## Neovim Plugin Setup

With the plugin, opening a Godot project in Neovim (outside of launching from Godot itself) will automatically start the server.

`lazy.nvim`:

```lua
{
  "Cretezy/godot-server.nvim"
}
```

## Reloading

If Neovim doesn't close properly (e.g. SIGKILL), it's possible it will won't cleanup the server socket file. The plugin provides the `:GodotServerReload` command to force the cleanup and restart the server. You can also manually do this with `rm .godot/server.pipe` if not using the plugin.

## Credits

Launch script based on [niscolas/nvim-godot](https://github.com/niscolas/nvim-godot).
