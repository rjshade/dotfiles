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

load( 'irb_rocket' )

