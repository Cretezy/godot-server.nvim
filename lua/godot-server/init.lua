local M = {}

-- Paths to check for project.godot file
local paths_to_check = { "/", "/../", "/../../" }

local function get_godot_project_path()
	local cwd = vim.fn.getcwd()

	for _, value in ipairs(paths_to_check) do
		if vim.uv.fs_stat(cwd .. value .. "project.godot") then
			return cwd .. value
		end
	end
end

function M.setup(opts)
	paths_to_check = opts.paths_to_check or paths_to_check

	M.start_server()
end

function M.start_server()
	local godot_project_path = get_godot_project_path()

	local server_path = godot_project_path .. "/.godot/server.pipe"
	local is_server_running = vim.uv.fs_stat(server_path)

	-- Start server if not already running
	if godot_project_path ~= "" and not is_server_running then
		vim.fn.serverstart(server_path)
	end
end

-- If Neovim doesn't properly close, it can leave the server pipe there. This removes it then restarts the server
function M.reload()
	local godot_project_path = get_godot_project_path()

	local server_path = godot_project_path .. "/.godot/server.pipe"
	local is_server_running = vim.uv.fs_stat(server_path)

	if is_server_running then
		os.remove(server_path)
	end

	M.start_server()
end

vim.api.nvim_command('command! GodotServerReload lua require("godot-server").reload()')

return M
