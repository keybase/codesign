exp = 
  defaults:
    filename: 'SIGNED.md'
  item_types:
    FILE:         0
    DIR:          1
    SYMLINK:      2
  presets:
    GIT:      'ignore anything as described by .gitignore files'
    KB:       'ignore anything as described by .kbignore files'
    DROPBOX:  'ignore .dropbox-cache and other Dropbox-related files'
    NONE:     'don\'t ignore anything'
  ignore_res:
    NONE:         0
    IGNORE:       1
    DONT_IGNORE:  2
  verify_codes:
    OK:                    0
    ALT_HASH_MATCH:        10  # 10...99 is a warning
    ALT_SYMLINK_MATCH:     11
    MISSING_DIR:           12
    ORPHAN_DIR:            13
    MISSING_FILE:          100 # 100... is an error
    ORPHAN_FILE:           101
    HASH_MISMATCH:         102
    WRONG_ITEM_TYPE:       103
    WRONG_EXEC_PRIVS:      104
    WRONG_SYMLINK:         105

  item_type_names: {}

for k,v of exp.item_types
  exp.item_type_names[v] = k

module.exports = exp
