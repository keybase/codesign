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
  rows = [['file', 'contents', 'size', 'exec']]
  for f in found_files
    col1 = ("  " for i in [0...f.depth]).join('') + utils.escape "#{f.path}"
    col2 = switch f.item_type
      when item_types.SYMLINK then "-> #{utils.escape(f.link)}"
      when item_types.DIR     then ""
      when item_types.FILE    then f.hash
    col3 = if (f.item_type is item_types.FILE) then f.size else ''
    col4 = if f.exec then 'x' else '-'
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
      info.exec      = cols[1] is 'x'
    else if cols[1] is '->'
      info.item_type = item_types.SYMLINK
      info.link      = cols[2]
      info.exec      = cols[3] is 'x'
    else
      info.item_type = item_types.FILE
      info.hash      = cols[1]
      info.size      = parseInt cols[2]
      info.exec      = cols[3] is 'x'
    res.push info
  res

# ======================================================================================================================

exports.to_md = (o) ->

  ignore_list = (utils.escape s for s in o.ignore).join '\n'
  file_list   = pretty_format_files o.found
  preset_list = ("#{p}  ##{constants.presets[p].toLowerCase()}" for p in o.presets).join '\n'

  res = 
  """
#### Verify

```
#{file_list}
```

#### Presets

```
#{preset_list}
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
  \#\#\#\# \s Presets
  \s*
  ```([^`]*)```  
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
    preset_rows = match[2].split('\n')[1...-1] # formatting correction
    ignore_rows = match[2].split('\n')[1...-1] # formatting correction
    version     = match[4]
    return {
      found:   files_from_pretty_format file_rows
      ignore:  (f for f in ignore_rows)
      presets: (f.replace /\#.*$/g for f in preset_rows)
      meta:
        version: version
    }
  else
    return null

# =====================================================================================================================