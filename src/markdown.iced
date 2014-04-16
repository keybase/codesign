
###

  A serializer/deserialized for Markdown from summarizer objects

###

# ======================================================================================================================

exports.to_md = (o) ->

  ignore_list = o.exclude.join '\n'
  file_list   = (JSON.stringify(f) for f in o.found).join '\n'
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