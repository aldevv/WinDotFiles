" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz


"bufwritepost  is when you save them
"bufreadpost  is when you open them

" Utilities
" auto save if is a python file
   " autocmd BufReadPost *.py :call Autosaving()
   "
" commenting in python
"    autocmd FileType python     nnoremap <buffer> gcc I#<esc>

" commenting in c,cpp
"    autocmd FileType c,cpp     nnoremap <buffer> gcc I//<esc>

" auto compile status bar dwm
    autocmd BufWritePost dwmstatus :!killall dwmstatus; setsid dwmstatus &

" auto compile suckless programs MODIFY TO GET BORDER
    " autocmd BufWritePost config.h !cd $(compileSuckless %); sudo make clean install
    autocmd BufWritePost config.h :call CompileSuck()

    function CompileSuck()
        let path = expand('%:p:h')
        let name = system('basename '.shellescape(path))
        " exec 'echo '.shellescape(name)
        silent exec '!cd ' . shellescape(path)
        if name =~ "dwm-6.2"
            echo name
            :exec '!changeWallpaperKeepBorders'
        else
            :exec '!sudo make clean install'
        endif



    endfunction
" auto compile latex if no vimtex
    autocmd BufWritePost,CursorHold,CursorHoldI *.tex :call CompileTex()

" auto compile markdown
    autocmd BufWritePost *.md :call CompileMd()

    function CompileTex()
        :w | silent exec "!latexmk -pdf %"
    endfunction

    function CompileMd()
        " the space at the end .pdf " is caused by the \n character
        let file = expand('%:p')

        let destinationFile = system("printf \"$(basename ". file. " .md).pdf\"")
        let destinationPath = expand('%:p:h')
        let destination = destinationPath .'/'. destinationFile

        let run = system("compileMd ".file." ".destination)
        if v:shell_error == 0
            :exec "!setsid zathura " . shellescape(destination)
        endif
    endfunction

" auto compile vim
    autocmd BufWritePost *.vim source %

" auto compile xresources
    autocmd BufWritePost *.Xresources !xrdb ~/.Xresources

" auto compile sxhkd
    autocmd BufWritePost *sxhkdrc !pkill sxhkd; setsid sxhkd &

" auto shortcuts
    autocmd BufWritePost,TextChanged sf,sd !$AUTOMATION/shortcut_maker_better

" functions
function Autosaving()
    autocmd TextChanged,TextChangedI <buffer> silent! write
endfunction
