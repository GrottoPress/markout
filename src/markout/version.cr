module Markout
  private macro set_version
    VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  end

  set_version
end
