exp = 
  defaults:
    filename: 'SIGNED.md'
  item_types:
    FILE: 0
    DIR:  1
    SYMLINK: 2
  item_type_names: {}

for k,v of exp.item_types
  exp.item_type_names[v] = k

module.exports = exp
