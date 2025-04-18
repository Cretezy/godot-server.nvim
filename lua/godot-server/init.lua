local M = {}

local function get_godot_project_path()
	return vim.fs.root(vim.fn.getcwd(), "project.godot")
end

function M.setup()
	M.start_server()
end

function M.start_server()
	local godot_project_path = get_godot_project_path()
	if not godot_project_path then
		return
	end

	local server_path = godot_project_path .. "/.godot/server.pipe"
	local is_server_running = vim.uv.fs_stat(server_path)

	-- Start server if not already running
	if not is_server_running then
		vim.fn.serverstart(server_path)
	end
end

-- If Neovim doesn't properly close, it can leave the server pipe there. This removes it then restarts the server
function M.reload()
	local godot_project_path = get_godot_project_path()
	if not godot_project_path then
		return
	end

	local server_path = godot_project_path .. "/.godot/server.pipe"
	local is_server_running = vim.uv.fs_stat(server_path)

	if is_server_running then
		os.remove(server_path)
	end

	M.start_server()
end

vim.api.nvim_create_user_command("GodotServerReload", M.reload, { force = true })

return M
