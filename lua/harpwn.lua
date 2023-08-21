local popup = require("popup")

function _c64cosmin_Lua_Harpwn_PopupCreate(lines_list)
	local height = #lines_list
	local width = 60
	local winid, win = popup.create(lines_list, {
		title = "Harpwn",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		border = { 1,1,1,1 },
		padding = { 0,0,0,0 },
		cursorline = 1,
	})

	local bufid = vim.api.nvim_win_get_buf(winid)

	vim.api.nvim_buf_set_keymap(bufid, "n", "q", ":call _c64cosmin_Harpwn_MenuClose(-1)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "0", ":call _c64cosmin_Harpwn_Go(0)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "1", ":call _c64cosmin_Harpwn_Go(1)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "2", ":call _c64cosmin_Harpwn_Go(2)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "3", ":call _c64cosmin_Harpwn_Go(3)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "4", ":call _c64cosmin_Harpwn_Go(4)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "5", ":call _c64cosmin_Harpwn_Go(5)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "6", ":call _c64cosmin_Harpwn_Go(6)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "7", ":call _c64cosmin_Harpwn_Go(7)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "8", ":call _c64cosmin_Harpwn_Go(8)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "9", ":call _c64cosmin_Harpwn_Go(9)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "k", ":call _c64cosmin_Harpwn_Menu_Key_k()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "j", ":call _c64cosmin_Harpwn_Menu_Key_j()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "K", ":call _c64cosmin_Harpwn_Menu_Key_K()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "J", ":call _c64cosmin_Harpwn_Menu_Key_J()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "C", ":call _c64cosmin_Harpwn_Menu_Key_C()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "D", ":call _c64cosmin_Harpwn_Menu_Key_D()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "?", ":call _c64cosmin_Harpwn_Menu_Key_help()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "<CR>", ":call _c64cosmin_Harpwn_Menu_Key_enter()<CR>", { silent = true, noremap = true })

	_G._c64cosmin_Harpwn_Lua_winid = winid

	return winid
end

function _c64cosmin_Lua_Harpwn_PopupClose()
	vim.api.nvim_win_close(_G._c64cosmin_Harpwn_Lua_winid, true)
end

function _c64cosmin_Lua_Harpwn_PopupRefresh()
	local bufid = vim.api.nvim_win_get_buf(_G._c64cosmin_Harpwn_Lua_winid)
	local config = vim.api.nvim_win_get_config(_G._c64cosmin_Harpwn_Lua_winid)

	local width = 0
	local lines = vim.api.nvim_buf_get_lines(bufid, 0, -1, false)
	for _, str in ipairs(lines) do
		local current_length = string.len(str)
		if current_length > width then
			width = current_length
		end
	end

	local height = #lines

	config.relative = "editor"
	config.width = width
	config.height = #lines
	config.row = math.floor(((vim.o.lines - height) / 2) - 1)
	config.col = math.floor((vim.o.columns - width) / 2)
    config.border = {
        {"╭", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╮", "FloatBorder"},
        {"│", "FloatBorder"},
        {"╯", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╰", "FloatBorder"},
        {"│", "FloatBorder"},
    },

	vim.api.nvim_win_set_config(_G._c64cosmin_Harpwn_Lua_winid, config)
end
