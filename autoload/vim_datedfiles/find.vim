function! vim_datedfiles#find#n_days_logbooks(n) abort " {{{
    let files = vim_datedfiles#directory_files#last_dated_n(a:n, expand("~/notes/work/logbook"))
    return l:files
endfunction " }}}

function! vim_datedfiles#find#n_days_journals(n) abort " {{{
    let files=vim_datedfiles#directory_files#last_dated_n(a:n, g:journal_dir)
    if len(files) == 0
        echom "No journals in last " . a:n . " days"
        return []
    endif
    return l:files
endfunction " }}}
