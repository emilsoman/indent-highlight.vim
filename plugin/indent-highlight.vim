" 237!
" To make sure plugin is loaded only once,
" and to allow users to disable the plugin
" with a global conf.
if exists("g:do_not_load_indent_highlight")
  finish
endif
let g:do_not_load_indent_highlight = 1

function! s:InitHighlightGroup()
  let s:group = "IndentHighlightGroup"
endfunction

function! s:CurrentBlockIndentPattern()
  let currentLineIndent = indent(".")
  let currentLineNumber = line(".")
  let startLineNumber = currentLineNumber
  let endLineNumber = currentLineNumber
  while indent(startLineNumber) == currentLineIndent
    startLineNumber -= 1
  endwhile
  while indent(endLineNumber) == currentLineIndent
    endLineNumber += 1
  endwhile
  echo "Start line no : " . startLineNumber
  echo "End line no : " . endLineNumber
endfunction

function! IndentHighlightDebug()
  call s:CurrentBlockIndentPattern()
endfunction
