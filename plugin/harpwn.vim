function! _c64cosmin_Harpwn_Init()
	if get(g:, "_c64cosmin_Harpwn_Initialized") != 1
		let g:_c64cosmin_Harpwn_ShowHelp = 0
		let g:_c64cosmin_Harpwn_ShowHelpTip = 1
		let g:_c64cosmin_Harpwn_CurrentIndex = 0
		let g:_c64cosmin_Harpwn_WindowList = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
		let g:_c64cosmin_Harpwn_BufferList = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
		let g:_c64cosmin_Harpwn_MenuWinID = -1
		let g:_c64cosmin_Harpwn_Initialized = 1
		if get(g:, "Harpwn_DontShowTip") == 1
			let g:_c64cosmin_Harpwn_ShowHelpTip = 0
		endif
	endif
endfunction

function! _c64cosmin_Harpwn_Set(index)
    let g:_c64cosmin_Harpwn_CurrentIndex = a:index
    " Save the current window ID
    let g:_c64cosmin_Harpwn_WindowList[a:index] = win_getid()
    let g:_c64cosmin_Harpwn_BufferList[a:index] = bufnr()
    echo 'Saved to index ' . a:index
endfunction

function! _c64cosmin_Harpwn_Delete(index)
    let g:_c64cosmin_Harpwn_WindowList[a:index] = -1
    let g:_c64cosmin_Harpwn_BufferList[a:index] = -1
endfunction

function! _c64cosmin_Harpwn_Go(index)
    let g:_c64cosmin_Harpwn_CurrentIndex = a:index
    let winid = g:_c64cosmin_Harpwn_WindowList[a:index]
    let bufid = g:_c64cosmin_Harpwn_BufferList[a:index]

    if winid != -1
        "try to move to that window
        exec 'call win_gotoid(' . winid . ')'
        "did this window id lead us to the proper buffer?
        if bufid != bufnr()
            "in current tab is the buffer open in another window?
            let window_list = range(1, winnr('$'))
            for it_winid in window_list
                let it_bufid = winbufnr(it_winid)
                "we found a window with the same buffer
                if it_bufid == bufid
                    exec 'call win_gotoid(' . it_winid . ')'
                    let g:_c64cosmin_Harpwn_WindowList[a:index] = win_getid()
                    return
                endif
            endfor

            "there is no window with that buffer open here
            "search for other tabs
            let tab_list = range(1, tabpagenr('$'))
            for it_tabid in tab_list
                let window_list = gettabinfo(it_tabid)[0].windows
                for it_winid in window_list
                    let it_bufid = winbufnr(it_winid)
                    "we found a window with the same buffer
                    if it_bufid == bufid
                        exec 'call win_gotoid(' . it_winid . ')'
                        let g:_c64cosmin_Harpwn_WindowList[a:index] = win_getid()
                        return
                    endif
                endfor
            endfor

            "there is not more window with that buffer, open a new window
            exec 'tab split'
            exec 'buffer' . bufid
            let g:_c64cosmin_Harpwn_WindowList[a:index] = win_getid()
        endif
    endif
endfunction

function! _c64cosmin_Harpwn_GetNext(increment)
    let index = g:_c64cosmin_Harpwn_CurrentIndex
    let length = len(g:_c64cosmin_Harpwn_WindowList)

    let bind_list = []
    if a:increment == 1
        let bind_list = extend(range(index + 1, length - 1), range(0, index))
    endif
    if a:increment == -1
        let bind_list = extend(range(index - 1, 0, -1), range(length - 1, index, -1))
    endif

    for it in bind_list
        if g:_c64cosmin_Harpwn_WindowList[it] != -1
            return it
        endif
    endfor

    return -1
endfunction

function! _c64cosmin_Harpwn_GetEmpty()
    let length = len(g:_c64cosmin_Harpwn_WindowList)

    for it in range(0, length - 1)
        if g:_c64cosmin_Harpwn_WindowList[it] == -1
            return it
        endif
    endfor

    return -1
endfunction

function! _c64cosmin_Harpwn_Next(increment)
    let it = _c64cosmin_Harpwn_GetNext(a:increment)
    if it != -1
        let winid = g:_c64cosmin_Harpwn_WindowList[it]
        if winid != -1
            call _c64cosmin_Harpwn_Go(it)
        endif
    endif
endfunction

function! _c64cosmin_Harpwn_Add()
    for it in g:_c64cosmin_Harpwn_BufferList
        if it == bufnr()
            return
        endif
    endfor

    let it = _c64cosmin_Harpwn_GetEmpty()
    if it != -1
        let winid = g:_c64cosmin_Harpwn_WindowList[it]
        if winid == -1
            call _c64cosmin_Harpwn_Set(it)
        endif
    endif
endfunction

function! _c64cosmin_Harpwn_Menu()
	if g:_c64cosmin_Harpwn_MenuWinID != -1
		call _c64cosmin_Harpwn_MenuClose(-1)
		return
	endif

    let entry_list = _c64cosmin_Harpwn_MenuBufferFill()

    let options = {
     \  'title' : ' Harpwn '
     \ ,'callback': '_c64cosmin_Harpwn_MenuSelect'
     \ ,'filter': '_c64cosmin_Harpwn_MenuFilter'
     \ ,'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
     \ ,'border': [1,1,1,1]
     \ ,'padding': [2,5,0,5]
     \ ,'pos': 'center'
     \ ,'zindex': 200
     \ ,'drag': 1
     \ ,'wrap': 0
     \ ,'cursorline': 1
     \ ,'mapping': 1
     \ }

    let g:_c64cosmin_Harpwn_MenuWinID = _c64cosmin_Harpwn_PopupCreate(entry_list, options)

	"put cursor to last jump
    for it in range(1, g:_c64cosmin_Harpwn_CurrentIndex)
        if g:_c64cosmin_Harpwn_WindowList[it] != -1
            call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! j')
        endif
    endfor
endfunction

function! _c64cosmin_Harpwn_MenuClose(index)
    call _c64cosmin_Harpwn_PopupClose(g:_c64cosmin_Harpwn_MenuWinID, a:index)
	let g:_c64cosmin_Harpwn_MenuWinID = -1
endfunction

function! _c64cosmin_Harpwn_MenuBufferFill()
	let bufid = winbufnr(g:_c64cosmin_Harpwn_MenuWinID)

    let entry_list = _c64cosmin_Harpwn_MenuGetLines()

    "do a clean up just in case
    call deletebufline(bufid, 1, '$')

    for it in range(0, len(entry_list) - 1)
        call setbufline(bufid, it + 1, entry_list[it])
    endfor

    return entry_list
endfunction

function! _c64cosmin_Harpwn_MenuGetLines()
    let entry_list = []

    for it in range(0, len(g:_c64cosmin_Harpwn_WindowList) - 1)
        if it != -1
            let bufid = g:_c64cosmin_Harpwn_BufferList[it]
            if bufid != -1
                let bufinfo = getbufinfo(bufid)[0]
                let indexnumber = it + 1
                if indexnumber == 10
                    let indexnumber = 0
                endif
                let newstring = '[' . indexnumber . '] ' . bufinfo.name
                call add(entry_list, newstring)
            endif
        endif
    endfor

	if len(entry_list) == 0
		call add(entry_list, "[x] No entries")
	endif

	call add(entry_list, "")
	if g:_c64cosmin_Harpwn_ShowHelpTip == 1 || g:_c64cosmin_Harpwn_ShowHelp == 1
		call add(entry_list, "")
		call add(entry_list, "?     - Toggle Help")
	else
		call add(entry_list, "")
	endif
	if g:_c64cosmin_Harpwn_ShowHelp == 1
		let g:_c64cosmin_Harpwn_ShowHelpTip = 0
		call add(entry_list, "jk    - move up/down")
		call add(entry_list, "JK    - move entry up/down")
		call add(entry_list, "D     - delete entry")
		call add(entry_list, "C     - clear all entries")
		call add(entry_list, "Enter - open that entry")
		call add(entry_list, "[num] - open entry with [num] id")
		call add(entry_list, "q     - close menu")
	endif

    return entry_list
endfunction

function! _c64cosmin_Harpwn_MenuSelect(winid, index)
    if a:index >= 0 && a:index <= 9
        call _c64cosmin_Harpwn_Go(a:index)
    endif
endfunction

function! _c64cosmin_Harpwn_MenuFilter(winid, key)
    if char2nr(a:key) == 27 || a:key == 'q'
        call _c64cosmin_Harpwn_MenuClose(-1)
    endif

    if char2nr(a:key) >= 48 && char2nr(a:key) <= 57
        let index = char2nr(a:key) - 48
        "if 0 is pressed it is actually the last in the array
        if index == 0
            let index = 10
        endif

        call _c64cosmin_Harpwn_MenuClose(index - 1)
    endif

    if char2nr(a:key) == 13
        let index = _c64cosmin_Harpwn_MenuGetIndexFromLine()
        call _c64cosmin_Harpwn_MenuClose(index)
    endif

    if a:key == "\<Up>" || a:key == "k"
		if _c64cosmin_Harpwn_MenuGetIndexFromCursor() > 1
			call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! k')
		endif
    endif

    if a:key == "\<Down>" || a:key == "j"
		if _c64cosmin_Harpwn_MenuGetIndexFromCursor() < _c64cosmin_Harpwn_MenuGetLineCount()
			call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! j')
		endif
    endif

    if a:key == "K"
        let index = g:_c64cosmin_Harpwn_MenuGetIndexFromLine()
        if index > 0
            if g:_c64cosmin_Harpwn_WindowList[index - 1] != -1
                call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! k')
            endif
            call _c64cosmin_Harpwn_SwapIndices(index - 1, index)
            call g:_c64cosmin_Harpwn_MenuBufferFill()
        endif
    endif

    if a:key == "J"
        let index = g:_c64cosmin_Harpwn_MenuGetIndexFromLine()
        if index < len(g:_c64cosmin_Harpwn_WindowList) - 1
            if g:_c64cosmin_Harpwn_WindowList[index + 1] != -1
                call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! j')
            endif
            call _c64cosmin_Harpwn_SwapIndices(index + 1, index)
            call g:_c64cosmin_Harpwn_MenuBufferFill()
        endif
    endif

    if a:key == "C"
		for it in range(0, len(g:_c64cosmin_Harpwn_WindowList) - 1)
			let g:_c64cosmin_Harpwn_WindowList[it] = -1
			let g:_c64cosmin_Harpwn_BufferList[it] = -1
		endfor
        call g:_c64cosmin_Harpwn_MenuBufferFill()
    endif

    if a:key == "D"
        let index = g:_c64cosmin_Harpwn_MenuGetIndexFromLine()
        let g:_c64cosmin_Harpwn_WindowList[index] = -1
        let g:_c64cosmin_Harpwn_BufferList[index] = -1
        call g:_c64cosmin_Harpwn_MenuBufferFill()
    endif

    if a:key == "?"
		let g:_c64cosmin_Harpwn_ShowHelp = 1 - g:_c64cosmin_Harpwn_ShowHelp
        call g:_c64cosmin_Harpwn_MenuBufferFill()
    endif

    return 1
endfunction

function! _c64cosmin_Harpwn_SwapIndices(a, b)
    let aux = g:_c64cosmin_Harpwn_WindowList[a:a]
    let g:_c64cosmin_Harpwn_WindowList[a:a] = g:_c64cosmin_Harpwn_WindowList[a:b]
    let g:_c64cosmin_Harpwn_WindowList[a:b] = aux
    let aux = g:_c64cosmin_Harpwn_BufferList[a:a]
    let g:_c64cosmin_Harpwn_BufferList[a:a] = g:_c64cosmin_Harpwn_BufferList[a:b]
    let g:_c64cosmin_Harpwn_BufferList[a:b] = aux
endfunction

function! _c64cosmin_Harpwn_MenuGetIndexFromCursor()
	return getcurpos(g:_c64cosmin_Harpwn_MenuWinID)[1]
endfunction

function! _c64cosmin_Harpwn_MenuGetLineCount()
	let l:count = 0
	for it in range(0, len(g:_c64cosmin_Harpwn_WindowList) - 1)
		if g:_c64cosmin_Harpwn_WindowList[it] != -1
			let l:count = l:count + 1
		endif
	endfor
	return l:count
endfunction

function! _c64cosmin_Harpwn_MenuGetIndexFromLine()
	let bufid = winbufnr(g:_c64cosmin_Harpwn_MenuWinID)
    let line = _c64cosmin_Harpwn_MenuGetIndexFromCursor()
    let linestring = getbufline(bufid, line)[0]
    let index = matchstr(linestring, '\[\zs\d\+\ze\]')
    if index == 0
        let index = 10
    endif
    return index - 1
endfunction

function! _c64cosmin_Harpwn_PopupCreate(info, options)
	if has('nvim')
		for [key, value] in items(a:options)
			echo key . ': ' . value
		endfor
		echo "glorf " . a:info
		echo "Doesn't work for Neovim yet :("
	else
		return popup_create(a:info, a:options)
	endif
endfunction

function! _c64cosmin_Harpwn_PopupClose(popupid, option)
	if has('nvim')
		echom "glorg " . a:popupid . " " . a:option
		echo "Doesn't work for Neovim yet :("
	else
		call popup_close(a:popupid, a:option)
	endif
endfunction

call _c64cosmin_Harpwn_Init()

command! -nargs=0 HarpwnAdd call _c64cosmin_Harpwn_Add()
command! -nargs=0 HarpwnMenu call _c64cosmin_Harpwn_Menu()
command! -nargs=1 HarpwnNext call _c64cosmin_Harpwn_Next(<q-args>)
command! -nargs=1 HarpwnGo call _c64cosmin_Harpwn_Go(<q-args>)
command! -nargs=1 HarpwnSet call _c64cosmin_Harpwn_Set(<q-args>)
command! -nargs=1 HarpwnDelete call _c64cosmin_Harpwn_Delete(<q-args>)
