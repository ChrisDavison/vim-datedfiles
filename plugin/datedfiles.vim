if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1

if !exists("g:datedfile_default_format")
    let g:datedfile_default_format="%Y-%m-%d--%A"
endif

if !exists("g:datedfile_default_header_format")
    let g:datedfile_default_header_format="%Y-%m-%d %A"
endif

command! -nargs=1 DatedFile call vim_datedfiles#new_or_jump(<f-args>)
command! -nargs=+ DatedFileWithFmt call vim_datedfiles#new_or_jump_with_fmt(<f-args>)

command! -nargs=? Journal call vim_datedfiles#capture#new_journal(<q-args>)
command! -nargs=? JournalHeader call vim_datedfiles#capture#new_single_day_journal(<q-args>)
command! -nargs=? Logbook call vim_datedfiles#capture#new_logbook(<q-args>)

command! -nargs=1 RecentJournals call vim_datedfiles#n_days_journals_fzf(<q-args>)
command! -nargs=? RecentJournalsQF call vim_datedfiles#n_days_journals_quickfix(<q-args>)
command! -nargs=? RecentJournalsH2 call vim_datedfiles#n_days_journals_quickfix_h2(<q-args>)

command! JournalFromURL call vim_datedfiles#capture#journal_for_url()
command! JournalHeaderFromURL call vim_datedfiles#capture#journal_header_for_url()
