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

function! vim_datedfiles#directory_files#last_dated_n(n, dir) abort "{{{
    let folder=expand(a:dir)
    if !isdirectory(l:folder)
        echom "Not a folder..." . l:folder
        return
    endif
    let files=split(glob(l:folder . "/*.md"), "\n")
    let dates=funcs#last_n_days(a:n)
    if len(dates) == 0
        return []
    end
    let pattern=join(l:dates, "\\|")
    let files=filter(l:files, {_, val -> match(val, l:pattern) >= 0})
    return reverse(l:files)
endfunction "}}}
