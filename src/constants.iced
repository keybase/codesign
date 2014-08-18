exp = 
  defaults:
    FILENAME:               'SIGNED.md'
  hash:
    ALG:                    'sha256'
    ENCODING:               'hex'
  item_types:
    FILE:                   0
    DIR:                    1
    SYMLINK:                2
  item_type_names:          {} # filled programmatically below
  presets:
    git:                    'ignore .git and anything as described by .gitignore files'
    kb:                     'ignore anything as described by .kbignore files'
    dropbox:                'ignore .dropbox-cache and other Dropbox-related files'
    svn:                    'ignore .svn and anything ignored by Subversion'
    none:                   'don\'t ignore anything'
  ignore_res:
    NONE:                   0
    IGNORE:                 1
    DONT_IGNORE:            2
  verify_codes:
    OK:                     0
    ALT_HASH_MATCH:         10  # 10...99 is a warning
    ALT_SYMLINK_MATCH:      11
    MISSING_DIR:            12
    ORPHAN_DIR:             13
    WRONG_EXEC_PRIVS:       14
    MISSING_FILE:           100 # 100... is an error
    ORPHAN_FILE:            101
    HASH_MISMATCH:          102
    WRONG_ITEM_TYPE:        103
    WRONG_SYMLINK:          105
  tweakables:
    WIN_SYMLINK_MAX_LEN:    1024

for k,v of exp.item_types
  exp.item_type_names[v] = k

module.exports = exp
