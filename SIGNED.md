#### Verify

```
file                                                             contents                                                          size  exec
.                                                                                                                                        x   
  ./.gitignore                                                   51e157e35910264bacdd03cfa1beb2e21638125f5667d5b2f3f88130441933d7  18    -   
  ./1                                                                                                                                    x   
    ./1/bar.txt                                                  -> foo.txt                                                              x   
    ./1/d1                                                                                                                               x   
      ./1/d1/apple.txt                                           303980bcb9e9e6cdec515230791af8b0ab1aaa244b58a8d99152673aa22197d0  6     -   
      ./1/d1/car.txt                                             f35ab270f45957f6c65656aefcbc37e799ad19eb454218e2f2e6bf4cd88638e5  4     -   
      ./1/d1/foobar.txt                                          -> ../foo.txt                                                           x   
      ./1/d1/loop                                                -> ../                                                                  x   
    ./1/d2                                                       -> d1                                                                   x   
    ./1/foo.txt                                                  b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c  4     -   
  ./2                                                                                                                                    x   
    ./2/file+with+space.txt                                      142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3  25    -   
    ./2/file_with_chars!%40#%24%25%5E%26.txt                     142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3  25    -   
    ./2/file_with_chars%5C%5B%5D%7B%7D%3A%60!%3C%3E%3F%3A_-.txt  142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3  25    -   
  ./3                                                                                                                                    x   
    ./3/executable.js                                            4600239d91638439b8c27777668a7e67985b6a7c1a93bb315d2d9988b64dae73  46    x   
    ./3/not_executable.js                                        ab73237fe40ecf22405751b988f5b0e3cfbfbe9d9ba194c8ba6eff8f7936ed62  30    -   
  ./4                                                                                                                                    x   
    ./4/4a                                                                                                                               x   
    ./4/4b                                                                                                                               x   
      ./4/4b/.gitignore                                          0b03cb75ed29f5c0bd93a9d7c52d47d3678f80e4934d0ba91938b0f388d2e50b  72    -   
```

#### Presets

```
git  # ignore anything as described by .gitignore files
dropbox  # ignore .dropbox-cache and other Dropbox-related files
```

#### Ignore

```

```

<!-- summarize version = 0.0.1 -->
