if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1

if !exists("g:datedfile")
    let g:datedfile = {
            \ 'journal': {
            \     'dir': '',
            \     'filename_format': '%Y-%m-%d',
            \     'header_format': '%Y-%m-%d %A',
            \     'default_tags': '@journal @unprocessed',
            \ },
            \ 'logbook': {
            \     'dir': '',
            \     'filename_format': '%Y-%m-%d',
            \     'header_format': '%Y-%m-%d %A',
            \     'default_tags': '@logbook',
            \ },
            \ 'lowercase_filename': 0,
            \ 'lowercase_time': 0,
            \ 'find_method': 'native',
        \ }
endif

" Journal stuff
command! -nargs=? Journal call vim_datedfiles#capture#new_file(g:datedfile.journal, <q-args>) 
command! -nargs=? JournalHeader call vim_datedfiles#capture#new_header(g:datedfile.journal, <q-args>)

command! -nargs=1 RecentJournals call vim_datedfiles#n_days_journals_fzf(<q-args>)
command! -nargs=? RecentJournalsQF call vim_datedfiles#n_days_journals_quickfix(<q-args>)
command! -nargs=? RecentJournalsH2 call vim_datedfiles#n_days_journals_quickfix_h2(<q-args>)

command! JournalFromURL call vim_datedfiles#capture#journal_for_url()
command! JournalHeaderFromURL call vim_datedfiles#capture#journal_header_for_url()

" Logbook stuff
command! -nargs=? Logbook call vim_datedfiles#capture#new_file(g:datedfile.logbook, <q-args>) 
command! -nargs=? LogbookHeader call vim_datedfiles#capture#new_header(g:datedfile.logbook, <q-args>)

command! -nargs=1 RecentLogbooks call vim_datedfiles#n_days_logbooks_fzf(<q-args>)
