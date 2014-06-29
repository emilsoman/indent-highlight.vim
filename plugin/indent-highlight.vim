" To make sure plugin is loaded only once,
" and to allow users to disable the plugin
" with a global conf.
if exists("g:do_not_load_indent_highlight")
  finish
endif
let g:do_not_load_indent_highlight = 1

function! s:InitHighlightGroup()
  " TODO: Make thi configurable
  highlight IndentHighlightGroup ctermbg=234
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

function! RefreshIndentHighlight()
  if exists("b:PreviousLine") && line('.') == b:PreviousLine
    return
  endif

  " Get the current block's pattern
  let pattern = s:CurrentBlockIndentPattern()
  if empty(pattern)
    "Do nothing if no block pattern is recognized
    return
  endif

  " Clear previous highlight if it exists
  if exists("b:currentMatch")
    call matchdelete(b:currentMatch)
  endif
  " Highlight the new pattern
  let b:currentMatch = matchadd("IndentHighlightGroup", pattern)
  let b:PreviousLine = line('.')
endfunction

call s:InitHighlightGroup()
autocmd CursorMoved,CursorMovedI * call RefreshIndentHighlight()
