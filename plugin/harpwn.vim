let g:_c64cosmin_Harpwn_MenuBufferName = "_c64cosmin_Harpwn_Menu_Buffer"

if get(g:, "_c64cosmin_Harpwn_Init") != 1
    let g:_c64cosmin_Harpwn_CurrentIndex = 0
    let g:_c64cosmin_Harpwn_WindowList = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    let g:_c64cosmin_Harpwn_BufferList = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    let g:_c64cosmin_Harpwn_MenuWinID = -1
    let g:_c64cosmin_Harpwn_MenuBufferID = -1
    let g:_c64cosmin_Harpwn_Init = 1
endif

function! _c64cosmin_Harpwn_Set(index)
    let g:_c64cosmin_Harpwn_CurrentIndex = a:index
    " Save the current window ID
    let g:_c64cosmin_Harpwn_WindowList[a:index] = win_getid()
    let g:_c64cosmin_Harpwn_BufferList[a:index] = bufnr()
    echo 'Saved to index ' . a:index
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
    call _c64cosmin_Harpwn_MenuBufferCreate()
    let entry_list = _c64cosmin_Harpwn_MenuBufferFill()

    let options = {
     \  'title' : ' Harpwn '
     \ ,'callback': '_c64cosmin_Harpwn_MenuSelect'
     \ ,'filter': '_c64cosmin_Harpwn_MenuFilter'
     \ ,'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
     \ ,'border': [1,1,1,1]
     \ ,'padding': [2,3,2,3]
     \ ,'pos': 'center'
     \ ,'zindex': 200
     \ ,'drag': 1
     \ ,'wrap': 0
     \ ,'cursorline': 1
     \ ,'mapping': 1
     \ }
    let g:_c64cosmin_Harpwn_MenuWinID = popup_create(g:_c64cosmin_Harpwn_MenuBufferID, options)
    for it in range(1, g:_c64cosmin_Harpwn_CurrentIndex)
        if g:_c64cosmin_Harpwn_WindowList[it] != -1
            call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! j')
        endif
    endfor
endfunction

function! _c64cosmin_Harpwn_MenuClose(index)
    call _c64cosmin_Harpwn_MenuBufferDelete()
    call popup_close(g:_c64cosmin_Harpwn_MenuWinID, a:index)
endfunction

function! _c64cosmin_Harpwn_MenuBufferCreate()
    if g:_c64cosmin_Harpwn_MenuBufferID == -1
        exec "badd " . g:_c64cosmin_Harpwn_MenuBufferName
        let g:_c64cosmin_Harpwn_MenuBufferID = bufnr(g:_c64cosmin_Harpwn_MenuBufferName)
        call setbufvar(g:_c64cosmin_Harpwn_MenuBufferID, '&hidden', 1)
        call setbufvar(g:_c64cosmin_Harpwn_MenuBufferID, '&readonly', 1)
        call setbufvar(g:_c64cosmin_Harpwn_MenuBufferID, '&buflisted', 0)
    endif
    let g:_c64cosmin_Harpwn_MenuBufferID = bufnr(g:_c64cosmin_Harpwn_MenuBufferName)
endfunction

function! _c64cosmin_Harpwn_MenuBufferDelete()
    if g:_c64cosmin_Harpwn_MenuBufferID != -1
        exec "bwipeout! " . g:_c64cosmin_Harpwn_MenuBufferName
        let g:_c64cosmin_Harpwn_MenuBufferID = -1
    endif
endfunction

function! _c64cosmin_Harpwn_MenuBufferFill()
    if g:_c64cosmin_Harpwn_MenuBufferID == -1
        return []
    endif

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

    call bufload(g:_c64cosmin_Harpwn_MenuBufferID)

    "do a clean up just in case
    call deletebufline(g:_c64cosmin_Harpwn_MenuBufferID, 1, '$')

    for it in range(0, len(entry_list) - 1)
        call setbufline(g:_c64cosmin_Harpwn_MenuBufferID, it + 1, entry_list[it])
    endfor

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
        call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! k')
    endif

    if a:key == "\<Down>" || a:key == "j"
        call win_execute(g:_c64cosmin_Harpwn_MenuWinID, 'normal! j')
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

    if a:key == "d"
        let index = g:_c64cosmin_Harpwn_MenuGetIndexFromLine()
        let g:_c64cosmin_Harpwn_WindowList[index] = -1
        let g:_c64cosmin_Harpwn_BufferList[index] = -1
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

function! _c64cosmin_Harpwn_MenuGetIndexFromLine()
    let line = getcurpos(g:_c64cosmin_Harpwn_MenuWinID)[1]
    let linestring = getbufline(g:_c64cosmin_Harpwn_MenuBufferID, line)[0]
    let index = matchstr(linestring, '\[\zs\d\+\ze\]')
    if index == 0
        let index = 10
    endif
    return index - 1
endfunction
