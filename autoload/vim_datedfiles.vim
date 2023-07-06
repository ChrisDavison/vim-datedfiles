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

function! vim_datedfiles#titlecase(sentence) abort "{{{
    let words=split(a:sentence, '\W\+')
    let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
    return join(l:titled, ' ')
endfunction "}}}

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

function! vim_datedfiles#n_days_logbooks_fzf(n) abort " {{{
    let files = vim_datedfiles#find#n_days_logbooks(a:n)
    if len(files) == 0
        echom "Run :Logbook to create a journal today"
        return
    endif
    call fzf#run(fzf#wrap({'source': l:files}))
endfunction " }}}

function! vim_datedfiles#n_days_journals_fzf(n) abort " {{{
    let files = vim_datedfiles#find#n_days_journals(a:n)
    if len(files) == 0
        echom "Run :Journal to create a journal today"
        return
    endif
    let jrnl=g:datedfile.journal.dir . "/"
    call map(l:files, { _, v -> substitute(l:v, l:jrnl, "", "")})
    " call fzf#run(fzf#wrap({'source': l:files, 'sink': funcref("<sid>open_journal")}))
    call fzf#run(fzf#wrap({'source': l:files, 'sink': 'e'}))
endfunction " }}}

function! vim_datedfiles#n_days_journals_quickfix(n) abort " {{{
    let n = 7
    if len(a:n) != 0
        let n = a:n
    endif
    let files_as_qflist=map(vim_datedfiles#find#n_days_journals(l:n), {key, val -> {'filename': v:val, 'lnum': 1, 'col': 1}})
    call setqflist(l:files_as_qflist)
endfunction " }}}

function! vim_datedfiles#n_days_journals_quickfix_h2(n) abort " {{{
    let n = 7
    if len(a:n) != 0
        let n = a:n
    endif
    let journals=vim_datedfiles#find#n_days_journals(l:n)
    call reverse(l:journals)
    exec "silent grep \'^\\#\\#\' " . join(l:journals, " ")
    copen
endfunction " }}}

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
            let header=l:header . " -- " . vim_datedfiles#titlecase(a:name)
        endif
        call append(0, l:header)
    endif

    " Finally, go to the end of the file and start writing
    norm G
endfunction "}}}
