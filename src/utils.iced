module.exports =
  escape: (s) ->
    ###
    we don't want to use either escape (deprecated) or encodeURIComponent (too ugly) and overescapes    
    ###
    res = ''
    for c, i in s
      if c.match /^[a-z0-9\/\._\-\~\#]$/i 
        res += c
      else
        res += encodeURIComponent(c).replace /%20/g, '+'
    return res

  unescape: (s) -> decodeURIComponent s.replace /\+/g, '%20'

  is_user_executable: (mode) -> !!(parseInt(100,8) & mode)