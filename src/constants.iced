exp = 
  defaults:
    filename: 'SIGNED.md'
  item_types:
    FILE: 0
    DIR:  1
    SYMLINK: 2
  presets:
    GIT:      'ignore anything as described by .gitignore files'
    KB:       'ignore anything as described by .kbignore files'
    DROPBOX:  'ignore .dropbox-cache and other Dropbox-related files'
    NONE:     'don\'t ignore anything'
  ignore_res:
    NONE:         0
    IGNORE:       1
    DONT_IGNORE:  2

  item_type_names: {}

for k,v of exp.item_types
  exp.item_type_names[v] = k

module.exports = exp
