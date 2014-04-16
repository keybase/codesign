
#### The signer

  * [keybase.io/chris](https://keybase.io/chris)

#### Verifying with [keybase](https://keybase.io/__/command_line/keybase#prerequisites)

```bash
# check this entire directory's contents,
# verify the signature at the bottom of this doc, 
# and check chris's identity proofs
> keybase code-sign verify
```

#### What's expected (122 files, 12 directories, 3 symlinks)

filename||perms|size
----- | ------- | ---- | ----
./ | | |
1/ | | |
` 1/bar.txt` |  -> `foo.txt` | |
1/d1/ | | |
&nbsp;&nbsp;&nbsp;&nbsp;1/d1/apple.txt |      [303980bcb9](#303980bcb9e9e6cdec515230791af8b0ab1aaa244b58a8d99152673aa22197d0) | 33188 | 6
&nbsp;&nbsp;&nbsp;&nbsp;1/d1/car.txt   |      [f35ab270f4](#f35ab270f45957f6c65656aefcbc37e799ad19eb454218e2f2e6bf4cd88638e5) | 33188 | 4
&nbsp;&nbsp;&nbsp;&nbsp;1/d1/foobar.txt |  -> ../foo.txt | |
&nbsp;&nbsp;&nbsp;&nbsp;1/d1/loop  |  -> ../ | |
1/d2 |  -> d1 | |
1/foo.txt |     [b5bb9d801](#b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c) | 33188 | 4

#### Ignores

 * `.git`
 * `.gitignore`
 * `~*`
 * `lib/*`

#### Tips

Any directory can be signed with keybase, to make its contents verifiable and owner proven. 
It is not specific to any version control system. Whether you're distributing zip files or sharing 
directories in Dropbox, consider signing their contents with Keybase.

More info: https://keybase.io/_/code-signing

#### Signature

```
------ BEGIN PGP BULLSHIT ------
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
opjweqfjioweqf ojwjofe jop wfqpjofwpjofw 
------ END PGP BULLSHIT -------
```