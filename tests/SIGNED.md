#### Verify

```
size  exec  file                                      contents                                                                                                                         
            ./                                                                                                                                                                         
18            .gitignore                              51e157e35910264bacdd03cfa1beb2e21638125f5667d5b2f3f88130441933d7                                                                 
              1/                                                                                                                                                                       
7               bar.txt                               ddab29ff2c393ee52855d21a240eb05f775df88e3ce347df759f0c4b80356c35                                                                 
                d1/                                                                                                                                                                    
7                 apple.txt                           7eab888a21ec9d5838e066eb38d92f7951e443ca40515e794913e66a58021e74|303980bcb9e9e6cdec515230791af8b0ab1aaa244b58a8d99152673aa22197d0
5                 car.txt                             d2f0ee2fe88d9b35f787afa876d2e8aad41eca6ef1e23dc449f4a2481f51fd81|f35ab270f45957f6c65656aefcbc37e799ad19eb454218e2f2e6bf4cd88638e5
10                foobar.txt                          308ac2f9c0fb8a962826d66acbb4ecfaa9feacaf5e5e06ca5df33a6a7805ae2a                                                                 
3                 loop                                fa08499e14d0113ba6794623f1badedcc8e9ae51cb5bafc7e14a5af1454bcfe7                                                                 
3                 loop2                               fa08499e14d0113ba6794623f1badedcc8e9ae51cb5bafc7e14a5af1454bcfe7                                                                 
2               d2                                    8b53639f152c8fc6ef30802fde462ba0be9cf085f7580dc69efd72e002abbb35                                                                 
5               foo.txt                               bf874c7dd3a83cf370fdc17e496e341de06cd596b5c66dbf3c9bb7f6c139e3ee|b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c
              2/                                                                                                                                                                       
25              file+with+space.txt                   142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3                                                                 
25              file_with_chars!%40#%24%25%5E%26.txt  142d6f59def242a4773e13ab9f1da44a053e1e87804579cf794b991ac96cced3                                                                 
              3/                                                                                                                                                                       
47              executable.js                         40cb04bbe0e4042efa8414947e09873373be8133fb201029fdf6c37cdee0767c|4600239d91638439b8c27777668a7e67985b6a7c1a93bb315d2d9988b64dae73
30              not_executable.js                     ab73237fe40ecf22405751b988f5b0e3cfbfbe9d9ba194c8ba6eff8f7936ed62                                                                 
              4/                                                                                                                                                                       
                4b/                                                                                                                                                                    
54                .gitignore                          6a530bf9bf5d26a67ff7372653c10f56ccd05a57885b1822b6025cd25ffbfd9d|a83f07906ff0a440507e1fda72dff7b3eb30003b8aa71709099e4604e4613a9c
5                 foo.please_ignore_me                bf874c7dd3a83cf370fdc17e496e341de06cd596b5c66dbf3c9bb7f6c139e3ee|b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c
              kb/                                                                                                                                                                      
23              .kbignore                             4bd39180d7220ccf5e6ab01285556e56e96912e41fcbd89f2d3cda5b2dcac7f1|253264c269132f1d41f786953b66b2486bbc8c49e40265e4cfa10b69a0332299
21              should_be_ok.md                       2546bee2a78598edde424fd4fc0b995de8f6d7c91dca89890b310f78af10fc2b|c7bc0835eb15d6b74b95e57100d6870aa20e95fb2913c5031036f8d317abe14a
                sub/                                                                                                                                                                   
5                 .kbignore                           db7e4c643912af4f8357d86e441363eab2b9dd4d404a9806c982a720fdf57363                                                                 
21                shouldnt_be_ignored.md              2546bee2a78598edde424fd4fc0b995de8f6d7c91dca89890b310f78af10fc2b|c7bc0835eb15d6b74b95e57100d6870aa20e95fb2913c5031036f8d317abe14a
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
