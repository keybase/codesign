#### Verify

```
size  exec  file                                      contents                                                        
            ./                                                                                                        
18            .gitignore                              51e157e35910264bacdd03cfa1beb2e21638125f5667d5b2f3f88130441933d7
              1/                                                                                                      
                bar.txt                               -> foo.txt                                                      
                d1/                                                                                                   
6                 apple.txt                           303980bcb9e9e6cdec515230791af8b0ab1aaa244b58a8d99152673aa22197d0
4                 car.txt                             f35ab270f45957f6c65656aefcbc37e799ad19eb454218e2f2e6bf4cd88638e5
                  foobar.txt                          -> ../foo.txt                                                   
                  loop                                -> ../                                                          
3                 loop2                               fa08499e14d0113ba6794623f1badedcc8e9ae51cb5bafc7e14a5af1454bcfe7
                d2                                    -> d1                                                           
4               foo.txt                               b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c
              2/                                                                                                      
25              file+with+space.txt                   142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3
25              file_with_chars!%40#%24%25%5E%26.txt  142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3
              3/                                                                                                      
46    x         executable.js                         4600239d91638439b8c27777668a7e67985b6a7c1a93bb315d2d9988b64dae73
30              not_executable.js                     ab73237fe40ecf22405751b988f5b0e3cfbfbe9d9ba194c8ba6eff8f7936ed62
              4/                                                                                                      
                4a/                                                                                                   
                4b/                                                                                                   
53                .gitignore                          a83f07906ff0a440507e1fda72dff7b3eb30003b8aa71709099e4604e4613a9c
4                 foo.please_ignore_me                b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c
              kb/                                                                                                     
22              .kbignore                             253264c269132f1d41f786953b66b2486bbc8c49e40265e4cfa10b69a0332299
18              should_be_ok.md                       c7bc0835eb15d6b74b95e57100d6870aa20e95fb2913c5031036f8d317abe14a
                sub/                                                                                                  
5                 .kbignore                           db7e4c643912af4f8357d86e441363eab2b9dd4d404a9806c982a720fdf57363
18                shouldnt_be_ignored.md              c7bc0835eb15d6b74b95e57100d6870aa20e95fb2913c5031036f8d317abe14a
```

#### Presets

```
git      # ignore anything as described by .gitignore files     
dropbox  # ignore .dropbox-cache and other Dropbox-related files
kb       # ignore anything as described by .kbignore files      
```

#### Ignore

```
/SIGNED.md
```

<!-- summarize version = 0.0.1 -->