dir-summarize
=============

directory contents summarizer - will be used for code signing feature

### TODO

  - kb preset
  - performance considerations:
    - alt_hash calculation creating unnecessary buffers and strings; switch to pipes entirely
  - pretty output on file not found errors, read-permission problems
  - handle poorly-parsing SIGNED.md file
  - tilde and pound signs in names