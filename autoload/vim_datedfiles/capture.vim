function! s:titlecase(str) abort "{{{
    let words=split(a:str, '\W\+')
    let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
    return join(l:titled, ' ')
endfunction "}}}


" Capture a journal entry as a h2 header
" keeping all entries for a day under a single file
function! vim_datedfiles#capture#new_single_day_journal(topic) abort " {{{
    if !exists("g:datedfile_journal_dir")
        echom "Need to set g:datedfile_journal_dir"
        return -1
    endif
    let root=g:datedfile_journal_dir
    call vim_datedfiles#new_or_jump_with_fmt(l:root, "%Y-%m-%d")
    if len(a:topic) != 0
        call append(line('$'), ['', '## ' . a:topic, ''])
        norm G
    else
        norm gg
    endif
endfunction " }}}

" Capture a journal entry as a h1 header in a new dated file
function! vim_datedfiles#capture#new_journal(topic, tags) abort " {{{
    let headerfmt=g:datedfile_default_header_format
    let g:datedfile_default_header_format="%Y-%m-%d ::"
    if len(a:topic) != 0
        let topic=a:topic
    else
        let topic=input("TOPIC: ")
    endif
    if !exists("g:datedfile_journal_dir")
        echom "Need to set g:datedfile_journal_dir"
        return -1
    endif
    let root=g:datedfile_journal_dir
    let succeeded=vim_datedfiles#new_with_fmt_and_name(l:root, g:datedfile_default_format, l:topic)
    let tags="@journal"
    if len(a:tags) != 0
        let tags.=" " . a:tags
    endif
    call append(1, ["", l:tags])
    let g:datedfile_default_header_format=l:headerfmt
    norm Go
    startinsert
endfunction " }}}

function! vim_datedfiles#capture#new_logbook(topic) " {{{
    let headerfmt=g:datedfile_default_header_format
    let g:datedfile_default_header_format="%Y-%m-%d ::"

    if !exists("g:datedfile_logbook_dir")
        echom "Need to set g:datedfile_journal_dir"
        return -1
    endif
    if len(a:topic) != 0
        let topic=a:topic
    else
        let topic=input("TOPIC: ")
    endif

    let succeeded=vim_datedfiles#new_with_fmt_and_name(simplify(g:datedfile_logbook_dir), g:datedfile_default_format, l:topic)
    let g:datedfile_default_header_format=l:headerfmt
    call append(line('$'), [""])
    norm Go
    startinsert
endfunction " }}}


function! vim_datedfiles#capture#new_single_day_logbook(topic) " {{{
    if !exists("g:datedfile_logbook_dir")
        echom "Need to set g:datedfile_journal_dir"
        return -1
    endif
    call vim_datedfiles#new_or_jump(simplify(g:datedfile_logbook_dir))
    if len(a:topic) != 0
        call append(line('$'), ["", "## " . s:titlecase(a:topic), ""])
        norm Go
        startinsert
    end
endfunction " }}}

function! vim_datedfiles#capture#journal_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, "^\[", "", "")
    let title=substitute(title, "\].*", "", "")
    call vim_datedfiles#capture#new_journal(l:title, "@article")
    call append(line('.'), ["Source: " . l:url, '', '- '])
    norm G$zO
    startinsert
endfunction "}}}



function! vim_datedfiles#capture#journal_header_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, "^\[", "", "")
    let title=substitute(title, "\].*", "", "")
    call vim_datedfiles#capture#new_single_day_journal(l:title)
    call append(line('.'), ["Source: " . l:url, '', '- '])
    norm G$zO
    startinsert
endfunction "}}}

