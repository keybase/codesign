dir-summarize
=============

directory contents summarizer - will be used for code signing feature

### TODO

  - kb preset
  - performance consideration: is_a_dir is getting called way too many times
    - consider file_info singleton that gets:
      - fstat
      - hash
      - whether it's binary or not
  - pretty output on file not found errors, read-permission problems
  - handle poorly-parsing SIGNED.md file
  - tilde and pound signs in names