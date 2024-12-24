function Scratch()
  vsplit
  noswapfile hide enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  "setlocal nobuflisted
  "lcd ~
  "file scratch
endfunction

command! -nargs=0 Scratch call Scratch()
