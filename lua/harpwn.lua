function _c64cosmin_Lua_Harpwn_PopupCreate(lines_list)
	local bufid = vim.api.nvim_create_buf(false, true)

	local width = 60
	local height = #lines_list
	local winid = vim.api.nvim_open_win(bufid, true, {
		relative = "editor",
		title = "Harpwn",
		title_pos = "center",
		width = width,
		height = height,
		row = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
    	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	})

	vim.api.nvim_set_option_value('cursorline', true, { win = winid })
	vim.api.nvim_set_option_value('signcolumn', "no", { win = winid })

	vim.api.nvim_buf_set_keymap(bufid, "n", "q", ":call _c64cosmin_Harpwn_MenuClose(-1)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "0", ":call _c64cosmin_Harpwn_MenuClose(9)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "1", ":call _c64cosmin_Harpwn_MenuClose(0)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "2", ":call _c64cosmin_Harpwn_MenuClose(1)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "3", ":call _c64cosmin_Harpwn_MenuClose(2)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "4", ":call _c64cosmin_Harpwn_MenuClose(3)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "5", ":call _c64cosmin_Harpwn_MenuClose(4)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "6", ":call _c64cosmin_Harpwn_MenuClose(5)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "7", ":call _c64cosmin_Harpwn_MenuClose(6)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "8", ":call _c64cosmin_Harpwn_MenuClose(7)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "9", ":call _c64cosmin_Harpwn_MenuClose(8)<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "<Up>", ":call _c64cosmin_Harpwn_Menu_Key_k()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "<Down>", ":call _c64cosmin_Harpwn_Menu_Key_j()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "k", ":call _c64cosmin_Harpwn_Menu_Key_k()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "j", ":call _c64cosmin_Harpwn_Menu_Key_j()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "K", ":call _c64cosmin_Harpwn_Menu_Key_K()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "J", ":call _c64cosmin_Harpwn_Menu_Key_J()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "C", ":call _c64cosmin_Harpwn_Menu_Key_C()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "D", ":call _c64cosmin_Harpwn_Menu_Key_D()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "?", ":call _c64cosmin_Harpwn_Menu_Key_help()<CR>", { silent = true, noremap = true })
	vim.api.nvim_buf_set_keymap(bufid, "n", "<CR>", ":call _c64cosmin_Harpwn_Menu_Key_enter()<CR>", { silent = true, noremap = true })

	_G._c64cosmin_Harpwn_Lua_winid = winid

	_c64cosmin_Lua_Harpwn_PopupRefresh()
	return winid
end

function _c64cosmin_Lua_Harpwn_PopupClose()
	local bufid = vim.api.nvim_win_get_buf(_G._c64cosmin_Harpwn_Lua_winid)
	vim.api.nvim_buf_delete(bufid, {})
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
	config.height = height
	config.row = math.floor(((vim.o.lines - height) / 2) - 1)
	config.col = math.floor((vim.o.columns - width) / 2)
    config.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

	vim.api.nvim_win_set_config(_G._c64cosmin_Harpwn_Lua_winid, config)
end
