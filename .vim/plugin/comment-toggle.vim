" Toggle comments on line of code
function! s:CommentToggle()
  let l:comment_char = ''
  let l:filetype = &filetype

  if l:filetype == 'sh' || l:filetype == 'python'
    let l:comment_char = '#'
  elseif l:filetype == 'javascript'
    let l:comment_char = '//'
  elseif l:filetype == 'vim'
    let l:comment_char = '"'
  endif

  " If a comment character is defined, toggle comment on the current line
  if l:comment_char != ''
    let l:current_line = getline('.')
    if stridx(l:current_line, l:comment_char) == 0
      " is already commented remove it
      let l:commented_line = substitute(l:current_line, l:comment_char . ' ', '', '')
    else
      let l:commented_line = comment_char . ' ' . current_line
    endif
    call setline('.', l:commented_line)
  endif
endfunction

noremap ' :call <SID>CommentToggle()<CR><LEFT>
inoremap ' <ESC>:call <SID>CommentToggle()<CR>i

