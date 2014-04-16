
<!-- BEGIN SIGNED PORTION -->

#### Expect (122 files, 12 directories, 3 symlinks)

```
./
  1/                                                                                     rw-
  1/bar.txt                                                                              rw-
  1/d1/                                                                                  rw-
    1/d1/apple.txt    303980bcb9e9e6cdec515230791af8b0ab1aaa244b58a8d99152673aa22197d0   rw- 6
    1/d1/car.txt      f35ab270f45957f6c65656aefcbc37e799ad19eb454218e2f2e6bf4cd88638e5   rwx 4
    1/d1/foobar.txt   -> ../foo.txt                                                      rw-
    1/d1/loop         -> ../                                                             rw-
  1/d2                -> d1                                                              rw-
  1/foo.txt           b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c   rw- 4
```

#### Ignore

```
.git
.gitignore
~*
lib/*
```
<!-- END SIGNED PORTION -->

<!-- BEGIN SIGNATURE PORTION -->

#### Signatures

##### https://keybase.io/chris

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

##### https://keybase.io/max

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

<!-- END SIGNATURE PORTION -->

<hr>

#### Using this file

This file was generated automatically by `keybase`, a command line application
which can sign and verify the contents of directories, both in and out of 
source control repositories. Anything from a personal Dropbox folder (for data integrity)
to a distributed zip file can be signed.

Keybase is different from similar programs because it automates identity proofs. With Keybase, you can tell
if a signer's public key matches the owner of certain
github, twitter, and other accounts. All without trusting webs of trust, public key servers, or even the Keybase server itself.

To verify this folder:

```bash
> keybase code-verify
```

If you are expecting a certain author to have signed this folder, it can 
be asserted and automated.

```bash
> keybase code-verify --assert keybase:chris --assert fingerprint:b5bb9d8014a0f9b1d61e21e79
```

For more info, check out ** https://keybase.io/_/code-signing ** to see what we're trying to achieve.
