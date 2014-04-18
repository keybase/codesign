path         = require 'path'
tablify      = require 'tablify'
{item_types} = require './constants'
utils        = require './utils'

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

files_from_pretty_format = (str_arr) ->
  res = []
  for s in str_arr
    s      = s.replace /(^\s+)|([\s\n]+$)/g, ''
    cols   = s.split /[\s]+/g
    fpath  = utils.unescape cols[0] 
    fparts = fpath.split '/'
    info =
      fname:         fparts[-1...][0]
      parent_path:   fparts[...-1].join '/'
      path:          fpath
    if cols.length is 2
      info.item_type = item_types.DIR
      info.mode      = parseInt cols[1]
    else if cols[1] is '->'
      info.item_type = item_types.SYMLINK
      info.link      = cols[2]
      info.mode      = parseInt cols[3]
    else
      info.item_type = item_types.FILE
      info.hash      = cols[1]
      info.size      = parseInt cols[2]
      info.mode      = parseInt cols[3]
    res.push info
  res

# ======================================================================================================================

exports.to_md = (o) ->

  ignore_list = (utils.escape s for s in o.ignore).join '\n'
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

<!-- summarize version = #{o.meta.version} -->
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
  \s* 
  \<\!--[\s]*summarize[\s]*version[\s]*=[\s]*([0-9a-z\.]*)[\s]*-->
  \s*
  $
  ///
  match  = rxx.exec str
  if match?
    file_rows   = match[1].split('\n')[2...-1] # formatting correction
    ignore_rows = match[2].split('\n')[1...-1] # formatting correction
    version     = match[3]
    return {
      found:  files_from_pretty_format file_rows
      ignore: (f for f in ignore_rows)
      meta:
        version: version
    }
  else
    return null

# =====================================================================================================================