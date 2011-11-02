def load( lib )
  begin
    require lib
    return true
  rescue LoadError => err
    warn "[irbrc] Couldn't load #{lib}: #{err}"
    return false
  end
end

# provides colorized output and syntax highlighting
if load 'wirb' 
  Wirb.start
end

# allows irb sessions to be edited in vim
load 'interactive_editor'

