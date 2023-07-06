function! vim_datedfiles#directory_files#last_n(dir, n) abort "{{{
    let fname=fnamemodify(a:dir, ":p") . "*"
    let files = glob(l:fname, 0, 1)[-a:n:]
    if len(l:files) > 0
        return l:files[len(l:files)-1]
    else
        echom "No matching files"
    endif
    return l:files
endfunction "}}}

function! vim_datedfiles#directory_files#last(dir) abort "{{{
    return vim_datedfiles#directory_files#last_n(a:dir, 1)
endfunction "}}}

function! vim_datedfiles#directory_files#last_n_qf(dir, n) abort "{{{
    let files=vim_datedfiles#directory_files#last_n(a:dir, a:n)
    let lastn_as_qf=map(l:files, {key, val -> {'filename':  v:val, 'lnum': 3, 'col': 1}})
    call setqflist(lastn_as_qf)
    cw
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

function! vim_datedfiles#directory_files#last_dated_n(n, dir) abort "{{{
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

