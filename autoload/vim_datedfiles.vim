"  _   _ _____ ___ _     ___ _______   __
" | | | |_   _|_ _| |   |_ _|_   _\ \ / /
" | | | | | |  | || |    | |  | |  \ V / 
" | |_| | | |  | || |___ | |  | |   | |  
"  \___/  |_| |___|_____|___| |_|   |_|  

function! s:filename(root, fmt, name) abort "{{{
    let time=strftime(printf("%s", a:fmt))
    if g:datedfile.lowercase_time
        let time=tolower(l:time)
    endif

    let name=g:datedfile.lowercase_filename ? tolower(a:name) : a:name
    if l:name != ""
        let l:name=substitute(l:name, '[^a-zA-Z0-9_\-. ]', '', 'g')
        let l:name=substitute(l:name, " ", "-", "g")
        let l:name=substitute(l:name, '---\+', "--", "g")
    endif

    let filename=l:time . "--" . l:name . ".md"
    let filepath=expand(a:root . "/" . l:filename)
    return substitute(l:filepath, "//", "/", "g")
endfunction "}}}

function! s:n_days_from_folder(n, folder) abort "{{{
    let files = vim_datedfiles#last_dated_n(a:n, a:folder)
    if len(files) == 0
        echom "No files in last " . a:n . " days"
    endif
    return l:files
endfunction "}}}

function! s:relative_date(delta) " {{{
    " TODO need to fix this to use the relevant filename format
    let fmt='+"' . substitute(g:datedfile_filename_format, "T.*", "", "") . '"'"
    return trim(system("date -d '" . a:delta . "days' " . l:fmt))
endfunction " }}}

function! s:last_n_days(n) abort " {{{
    let dates=[]
    for delta in range(-a:n+1, 0)
        let rel=s:relative_date(l:delta)
        let rel=substitute(l:rel, 'T.*', '', '')
        call add(l:dates, l:rel)
    endfor
    return l:dates
endfunction " }}}

function! s:open_journal(filename) abort "{{{
    exec "edit " . g:datedfile.journal.dir . "/" . a:filename
endfunction "}}}

function! s:n_logbooks_quickfix(n) abort " {{{
    let n=a:n
    if strlen(a:n) == 0
        let l:n=10
    endif
    let last7=<sid>last_n_logbooks(l:n)
    let last7_as_qf=map(last7, {key, val -> {
                \ 'filename': v:val,
                \ 'lnum': 3, 'col': 1,
                \ 'text': readfile(v:val)[0][2:]}})
    call setqflist(last7_as_qf)
    copen
    cfirst
endfunction " }}}

function! s:titlecase(sentence) abort "{{{
    let words=split(a:sentence, '\W\+')
    let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
    return join(l:titled, ' ')
endfunction "}}}

" __     _____ _______        __
" \ \   / /_ _| ____\ \      / /
"  \ \ / / | ||  _|  \ \ /\ / / 
"   \ V /  | || |___  \ V  V /  
"    \_/  |___|_____|  \_/\_/   

function! vim_datedfiles#n_days_logbooks(n) abort " {{{
    return <sid>n_days_from_folder(a:n, g:datedfile.logbook.dir)
endfunction " }}}

function! vim_datedfiles#n_days_journals(n) abort " {{{
    return <sid>n_days_from_folder(a:n, g:datedfile.journal.dir)
endfunction " }}}

function! vim_datedfiles#n_days_logbooks_fzf(n) abort " {{{
    let files = vim_datedfiles#n_days_logbooks(a:n)
    if len(files) == 0
        echom "Run :Logbook to create a journal today"
        return
    endif
    call fzf#wrap({'source': l:files}))
endfunction " }}}

function! vim_datedfiles#n_days_journals_fzf(n) abort " {{{
    let files = vim_datedfiles#n_days_journals(a:n)
    if len(files) == 0
        echom "Run :Journal to create a journal today"
        return
    endif
    let jrnl=g:datedfile.journal.dir . "/"
    call map(l:files, { _, v -> substitute(l:v, l:jrnl, "", "")})
    " call fzf#wrap({'source': l:files, 'sink': funcref("<sid>open_journal")}))
    call fzf#wrap({'source': l:files, 'sink': 'e'})
endfunction " }}}

function! vim_datedfiles#n_days_journals_quickfix(n) abort " {{{
    let n = 7
    if len(a:n) != 0
        let n = a:n
    endif
    let files_as_qflist=map(vim_datedfiles#n_days_journals(l:n), {key, val -> {'filename': v:val, 'lnum': 1, 'col': 1}})
    call setqflist(l:files_as_qflist)
endfunction " }}}

function! vim_datedfiles#n_days_journals_quickfix_h2(n) abort " {{{
    let n = 7
    if len(a:n) != 0
        let n = a:n
    endif
    let journals=vim_datedfiles#n_days_journals(l:n)
    call reverse(l:journals)
    exec "silent grep \'^\\#\' " . join(l:journals, " ")
    copen
endfunction " }}}

"   ____    _    ____ _____ _   _ ____  _____ 
"  / ___|  / \  |  _ \_   _| | | |  _ \| ____|
" | |     / _ \ | |_) || | | | | | |_) |  _|  
" | |___ / ___ \|  __/ | | | |_| |  _ <| |___ 
"  \____/_/   \_\_|    |_|  \___/|_| \_\_____|

function! vim_datedfiles#new_or_jump(config, name) abort "{{{
    if !isdirectory(expand(a:config.dir))
        echom "Invalid directory: `" . a:config.dir . "`"
        return 0
    endif
    let filename=s:filename(a:config.dir, a:config.filename_format, a:name)

    if filereadable(l:filename)
        exec "edit " . l:filename
    else
        let folder=fnamemodify(l:filename, ":p:h")
        if !isdirectory(l:folder)
            call mkdir(l:folder, "p")
        endif
        exec "edit " . l:filename
        let header="# " . strftime(a:config.header_format)
        if a:name != ""
            let header=l:header . " -- " . <sid>titlecase(a:name)
        endif
        call append(0, l:header)
    endif

    " Finally, go to the end of the file and start writing
    norm G
endfunction "}}}

" Capture a journal entry as a standalone file
function! vim_datedfiles#new_file(config, topic) abort "{{{
    if len(a:topic) != 0
        let topic=a:topic
    else
        let topic=input("TOPIC: ")
    endif
    let succeeded=vim_datedfiles#new_or_jump(a:config, l:topic)
    if l:succeeded != 0
        echom "Failed to create file"
        return -1
    endif
    if a:config.default_tags != ""
        call append(1, ["", a:config.default_tags])
    endif
    norm Go
    startinsert
endfunction "}}}

" Capture a journal entry as a h2 entry within a file
function! vim_datedfiles#new_header(config, topic) abort "{{{
    if len(a:topic) != 0
        let topic=a:topic
    else
        let topic=input("TOPIC: ")
    endif
    let succeeded=vim_datedfiles#new_or_jump(a:config, "")
    if l:succeeded != 0
        echom "Failed to create file"
        return -1
    endif
    call append(line('$'), ["", "#titlecase(l:topic), "", "", a:config.default_tags])
    norm Go
    startinsert
endfunction "}}}

function! vim_datedfiles#journal_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, '^\[\(.*\)\].*', '\1', "")
    let title=substitute(title, '|', "-", "")
    let conf=copy(g:datedfile.journal)
    let l:conf.default_tags.=" @article"
    call vim_datedfiles#new_file(l:conf, l:title)
    call append(line('$'), ["Source: " . l:url, '', '- '])
    norm G$
    startinsert
endfunction "}}}

function! vim_datedfiles#journal_header_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, "^\[", "", "")
    let title=substitute(title, "\].*", "", "")
    let conf=copy(g:datedfile.journal)
    let l:conf.default_tags.=" @article"
    call vim_datedfiles#new_header(l:conf, l:title)
    call append(line('$'), ["Source: " . l:url, '', '- '])
    norm G$
    startinsert
endfunction "}}}

"  _____ ___ _   _ ____    _____ ___ _     _____ ____  
" |  ___|_ _| \ | |  _ \  |  ___|_ _| |   | ____/ ___| 
" | |_   | ||  \| | | | | | |_   | || |   |  _| \___ \ 
" |  _|  | || |\  | |_| | |  _|  | || |___| |___ ___) |
" |_|   |___|_| \_|____/  |_|   |___|_____|_____|____/ 

function! vim_datedfiles#last_n(dir, n) abort "{{{
    let fname=fnamemodify(a:dir, ":p") . "*"
    let files = glob(l:fname, 0, 1)[-a:n:]
    if len(l:files) > 0
        return l:files[len(l:files)-1]
    else
        echom "No matching files"
    endif
    return l:files
endfunction "}}}

function! vim_datedfiles#last(dir) abort "{{{
    return vim_datedfiles#last_n(a:dir, 1)
endfunction "}}}

function! vim_datedfiles#last_n_qf(dir, n) abort "{{{
    let files=vim_datedfiles#last_n(a:dir, a:n)
    let lastn_as_qf=map(l:files, {key, val -> {'filename':  v:val, 'lnum': 3, 'col': 1}})
    call setqflist(lastn_as_qf)
    cw
endfunction "}}}

function! vim_datedfiles#last_dated_n(n, dir) abort "{{{
    let folder=expand(a:dir)
    if !isdirectory(l:folder)
        echom "Not a folder..." . l:folder
        return
    endif
    if g:datedfile.find_method == "native"
        let files=split(glob(l:folder . "/*.md"), "\n")
        let dates=s:last_n_days(a:n)
        if len(dates) == 0
            return []
        end
        let pattern=join(l:dates, "\\|")
        let files=filter(l:files, {_, val -> match(val, l:pattern) >= 0})
        return reverse(l:files)
    else
        return reverse(systemlist("fd . -e md --changed-within " . a:n . "d " . a:dir))
    endif
endfunction "}}}

