dir-summarize
=============

directory contents summarizer - will be used for code signing feature

### TODO

  - need to remove glob-to-regexp and write my own
  - git, kb, Dropbox presets
  - performance consideration: pipelining summarizer so multiple files at once
  - performance consideration: is_a_dir is getting called way too many times
  - pretty output on file not found errors, read-permission problems
  - handle poorly-parsing SIGNED.md file
  - tilde and pound signs in names