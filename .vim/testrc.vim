" another way to search
" nnoremap <leader>s :g//#<Left><Left>
" show partial Normal mode command on Command-line and character/line/block-selection for Visual mode
set showcmd

" Universal opposite of J
function! BreakHere()
	s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
	call histdel("/", -1)
endfunction

nnoremap <leader>J :<C-u>call BreakHere()<CR>

" automatic_file_marks
augroup AutomaticMarks
    autocmd!
    autocmd BufLeave *.js,*.ts    normal! mJ
    autocmd BufLeave .env*        normal! mE
    autocmd BufLeave *.md         normal! mM
augroup END

" open new tab, netrw on notes dir
function! Notes()
  let l:dir_line = system('grep _DIR ~/.config/notes/config')
  let l:dir = split(l:dir_line, '=')[1]
  tabnew
  execute 'cd ' .  l:dir
  pwd
  Explore .
endfunction
nnoremap <leader>N :call Notes()<CR>
