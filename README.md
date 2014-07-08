indent-highlight.vim
====================

Vim plugin to highlight current block based on indentation levels.

## Features
  * Works with multiple buffers/splits/windows
  * Configurable to set custom highlight color
  * Easily toggle highlights

## Usage

`<Leader>ih` toggles the current block (guessed by indentation levels).

To map your custom shortcut, add this to your vimrc.

    map <silent> SHORTCUT :IndentHighlightToggle<CR>

For example, to map :IndentHighlightToggle to <leader>i ,

    map <silent> <leader>i :IndentHighlightToggle<CR>

## Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  Pathogen
  *  `git clone https://github.com/emilsoman/indent-highlight.vim ~/.vim/bundle/indent-highlight.vim`
*  NeoBundle
  *  `NeoBundle 'emilsoman/indent-highlight.vim'`
*  Vundle
  *  `Plugin 'emilsoman/indent-highlight.vim'`
*  manual
  *  copy all of the files into your `~/.vim` directory

## Configuration

These configurations are available to set in your `~/.vimrc`

    let g:indent_highlight_disabled = 1       " Disables the plugin, default 0
    let g:indent_highlight_bg_color = 235     " Color to be used for highlighting, default 233
    let g:indent_highlight_start_disabled = 0 " Disable indent-highlight, enable by explicitly toggling, default 1

## License

MIT License. Copyright (c) 2014 Emil Soman
