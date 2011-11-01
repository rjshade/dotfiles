def load( lib )
  begin
    require lib
    return true
  rescue LoadError => err
    warn "[irbrc] Couldn't load #{lib}: #{err}"
    return false
  end
end

if load( 'wirble' )
  Wirble.init
  Wirble.colorize
end

# prints results on same line as expression
load( 'irb_rocket' )

# every object gets an .ls method which displays color coded methods
load( 'looksee' )

# 'awesome_print myObj' to pretty print an object
load( 'awesome_print' )

