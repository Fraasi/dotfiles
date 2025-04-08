" Theme {{{
  " To see a list of ready-to-use themes,
  " :colorscheme [space] [Ctrl+d]
  " colorscheme torte
  try
    if has("termguicolors")
      set termguicolors
    endif
    packadd! onedark.vim
    let g:onedark_color_overrides = {
        \ "background": {"gui": "#131313", "cterm": "233", "cterm16": "0" },
        \ "purple": { "gui": "#C678DF", "cterm": "170", "cterm16": "5" }
        \}
    colorscheme onedark
  catch
    colorscheme slate
  endtry
" }}}

" codeium {{{
"imap <script><silent><nowait><expr> <C-g> codeium#Accept()
  inoremap Ä  <Cmd>call codeium#CycleCompletions(1)<CR>
  inoremap Ö  <Cmd>call codeium#CycleCompletions(-1)<CR>
  inoremap <C-l>  <Cmd>call codeium#Clear()<CR>
  " Manually trigger suggestion
  inoremap <S-Tab> <Cmd>call codeium#Complete()<CR>
  inoremap <C-a>  <Cmd>call codeium#Accept()<CR>
  nnoremap <leader>cd <Cmd>CodeiumDisable<CR>
  nnoremap <leader>ce <Cmd>CodeiumEnable<CR>
" }}}

" coc.nvim {{{
  " packadd! coc.nvim
  " https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-cr-to-confirm-completion
  let g:coc_global_extensions = ['coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-pyright', 'coc-sh']
  " inoremap <expr> <S-tab> coc#pum#visible() ? coc#pum#confirm() : "\<S-tab>"
  source ~/.vim/cocrc.vim
" }}}

" disable on start {{{
  " For a command defined by a plugin, a solution like the following usually works (since VimEnter is triggered at the end of :help startup)
  augroup disable_on_start
   autocmd!
   autocmd VimEnter * CodeiumDisable
  augroup end
" }}}

" fzf.vim {{{
  set runtimepath+=~/.fzf
  packadd! fzf.vim
  nnoremap f :Files<CR>
  nnoremap b :Buffers<CR>
  nnoremap <leader>fc :Commands<CR>
" }}}

" iron.vim {{{
    let g:iron_keymaps = {
  \ "toggle_repl": "<leader>rr",
  \ "toggle_vertical": "<leader>rv",
  \ "repl_restart": "<leader>rR",
  \ "repl_kill": "<leader>rk",
  \ "send_line": "<leader>sl",
  \ "send_visual": "<leader>sp",
  \ "send_paragraph": "<leader>sp",
  \ "send_until_cursor": "<leader>su",
  \ "send_file": "<leader>sf",
  \ "send_cancel": "<leader>sc",
  \ "send_blank_line": "<leader>s<CR>",
  \ }
" }}}
