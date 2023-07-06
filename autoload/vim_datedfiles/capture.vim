" Capture a journal entry as a standalone file
" e.g.
" 2020-01-01--<TOPIC>.md
function! vim_datedfiles#capture#new_file(config, topic) abort "{{{
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
" e.g.
" 2020-01-01.md
" with the following contents
"
"     # 2020-01-01
"
"     ## <TOPIC>
function! vim_datedfiles#capture#new_header(config, topic) abort "{{{
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
    call append(line('$'), ["", "## " . vim_datedfiles#titlecase(l:topic), "", "", a:config.default_tags])
    norm Go
    startinsert
endfunction "}}}


function! vim_datedfiles#capture#journal_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, '^\[\(.*\)\].*', '\1', "")
    let title=substitute(title, '|', "-", "")
    let conf=copy(g:datedfile.journal)
    let l:conf.default_tags.=" @article"
    call vim_datedfiles#capture#new_file(l:conf, l:title)
    call append(line('$'), ["Source: " . l:url, '', '- '])
    norm G$
    startinsert
endfunction "}}}


function! vim_datedfiles#capture#journal_header_for_url() abort "{{{
    let url=getreg('*')
    let title=substitute(l:url, "^\[", "", "")
    let title=substitute(title, "\].*", "", "")
    let conf=copy(g:datedfile.journal)
    let l:conf.default_tags.=" @article"
    call vim_datedfiles#capture#new_header(l:conf, l:title)
    call append(line('$'), ["Source: " . l:url, '', '- '])
    norm G$
    startinsert
endfunction "}}}
