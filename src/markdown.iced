path         = require 'path'
tablify      = require 'tablify'
{item_types} = require './constants'
utils        = require './utils'
{PackageJson} = require './package'

###

  A serializer/deserialized for Markdown from summarizer objects

###

# ======================================================================================================================

max_depth = (found_files) ->
  max_depth = 0
  max_depth = Math.max(f.depth, max_depth) for f in found_files
  max_depth

pretty_format_files = (found_files) ->
  rows = [['file', 'contents', 'size', 'mode']]
  for f in found_files
    col1 = ("  " for i in [0...f.depth]).join('') + utils.escape(path.join(f.parent_path, f.fname))
    col2 = switch f.item_type
      when item_types.SYMLINK then "-> #{utils.escape(f.link)}"
      when item_types.DIR     then ""
      when item_types.FILE    then f.hash
    col3 = if (f.item_type is item_types.FILE) then f.size else ''
    col4 = f.mode
    rows.push [ col1, col2, col3, col4 ]
  return tablify rows, {
    show_index:     false
    row_start:      ''
    row_end:        ''
    spacer:         '  '
    row_sep_char:   ''
  }

# ======================================================================================================================

exports.to_md = (o) ->

  label = (f) -> ("  " for i in [0...f.depth]).join("") + path.join(f.parent_path, f.fname)

  ignore_list = o.exclude.join '\n'
  file_list   = pretty_format_files o.found
  res = 
  """
#### Verify

```
#{file_list}
```

#### Ignore

```
#{ignore_list}
```

<!-- dir_signer version = #{(new PackageJson()).version()} -->
"""

  return res

# ======================================================================================================================

exports.from_md = (str) ->
  rxx = ///
  ^ \s*
  \#\#\#\# \s Verify
  \s*
  ```([^`]*)```
  \s*
  \#\#\#\# \s Ignore
  \s*
  ```([^`]*)```
  \s* $
  ///
  match  = rxx.exec str
  if match?
    return {
      file_list:   match[1]
      ignore_list: match[2]
    }
  else
    return null

# =====================================================================================================================