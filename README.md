# DatedFiles

This plugin is a simple plugin to create files similar to:

    ~/notes/journal/20200101-Friday.md

It exposes two commands, `DatedFile` and `DatedFileWithFmt`

The above file was created using:

    DatedFile ~/notes/journal

A file like `~/notes/calendar/2020-01_January.md` could be created using:

    DatedFileWithFmt ~/notes/calendar %Y-%m_%B

## Installation

I use `vim-plug`.

Simply add `Plug 'chrisdavison/vim-datedfiles'` to your plugins.
