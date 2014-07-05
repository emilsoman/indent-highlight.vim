" To make sure plugin is loaded only once,
" and to allow users to disable the plugin
" with a global conf.
if exists("g:do_not_load_indent_highlight")
  finish
endif
let g:do_not_load_indent_highlight = 1

"let g:indent_highlight_disabled = 0
"let b:indent_highlight_disabled = g:indent_highlight_disabled
if !exists("g:indent_highlight_bg_color")
  let g:indent_highlight_bg_color = 233
endif

function! s:InitHighlightGroup()
  exe 'hi IndentHighlightGroup guibg=' . g:indent_highlight_bg_color . ' ctermbg=' . g:indent_highlight_bg_color
endfunction

function! s:CurrentBlockIndentPattern()
  let currentLineIndent = indent(".")
  let currentLineNumber = line(".")
  let startLineNumber = currentLineNumber
  let endLineNumber = currentLineNumber
  let pattern = ""

  while s:IsLineOfSameIndent(startLineNumber, currentLineIndent)
    if startLineNumber < line("w0")
      break
    endif
    let startLineNumber -= 1
  endwhile

  while s:IsLineOfSameIndent(endLineNumber, currentLineIndent)
    if endLineNumber > line("w$")
      break
    endif
    let endLineNumber += 1
  endwhile

  let b:PreviousBlockStartLine = startLineNumber
  let b:PreviousBlockEndLine = endLineNumber
  return '\%>' . startLineNumber . 'l\%<' . endLineNumber . 'l.*'
endfunction

function! s:IsLineOfSameIndent(lineNumber, referenceIndent)
  " If currently on empty line, do not highlight anything
  if a:referenceIndent == 0
    return 0
  endif

  let lineIndent = indent(a:lineNumber)

  " lineNumber has crossed bounds.
  if lineIndent == -1
    return 0
  endif

  " Treat empty lines as current block
  if empty(getline(a:lineNumber))
    return 1
  endif

  " Treat lines with greater indent as current block
  if lineIndent >= a:referenceIndent
    return 1
  endif

  return 0
endfunction

function! RefreshIndentHighlightOnCursorMove()
  " Do nothing if cursor has not moved to a new line
  if exists("b:PreviousLine") && line('.') == b:PreviousLine
    return
  endif
  call s:DoHighlight()
endfunction

function! RefreshIndentHighlightOnBufEnter()
  call s:DoHighlight()
endfunction

function! s:DoHighlight()
  " Do nothing if indent_highlight_disabled is set globally or for window
  if get(g:, 'indent_highlight_disabled', 0) || get(w:, 'indent_highlight_disabled', 0)
    return
  endif

  " Get the current block's pattern
  let pattern = s:CurrentBlockIndentPattern()
  if empty(pattern)
    "Do nothing if no block pattern is recognized
    return
  endif

  " Clear previous highlight if it exists
  if get(w:, 'currentMatch', 0)
    call matchdelete(w:currentMatch)
    let w:currentMatch = 0
  endif

  " Highlight the new pattern
  let w:currentMatch = matchadd("IndentHighlightGroup", pattern)
  let b:PreviousLine = line('.')
endfunction

function! s:IndentHighlightHide()
  if get(w:, 'currentMatch', 0)
    call matchdelete(w:currentMatch)
    let w:currentMatch = 0
  endif
  let w:indent_highlight_disabled = 1
endfunction

function! s:IndentHighlightShow()
  let w:indent_highlight_disabled = 0
  call s:DoHighlight()
endfunction

function! s:IndentHighlightToggle()
  if get(w:, 'indent_highlight_disabled', 0)
    call s:IndentHighlightShow()
  else
    call s:IndentHighlightHide()
  endif
endfunction

call s:InitHighlightGroup()

augroup indent_highlight
  autocmd!

  if !get(g:, 'indent_highlight_disabled', 0)
    " On cursor move, we check if line number has changed
    autocmd CursorMoved,CursorMovedI * call RefreshIndentHighlightOnCursorMove()
    " On buffer entry, we just highlight current block
    autocmd BufWinEnter * call RefreshIndentHighlightOnBufEnter()
  endif

augroup END

" Default mapping is <Leader>ih
map <unique> <silent> <Leader>ih :IndentHighlightToggle<CR>

" If this command doesn't exist, create one.
" This is the only command available to the users.
if !exists(":IndentHighlightToggle")
  command IndentHighlightToggle  :call s:IndentHighlightToggle()
endif
