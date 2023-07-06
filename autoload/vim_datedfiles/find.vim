function! s:n_days_from_folder(n, folder) abort "{{{
    let files = vim_datedfiles#directory_files#last_dated_n(a:n, a:folder)
    if len(files) == 0
        echom "No files in last " . a:n . " days"
    endif
    return l:files
endfunction "}}}

function! vim_datedfiles#find#n_days_logbooks(n) abort " {{{
    return <sid>n_days_from_folder(a:n, g:datedfile.logbook.dir)
endfunction " }}}

function! vim_datedfiles#find#n_days_journals(n) abort " {{{
    return <sid>n_days_from_folder(a:n, g:datedfile.journal.dir)
endfunction " }}}
