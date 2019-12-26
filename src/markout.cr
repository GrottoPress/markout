require "./markout/version"
require "./markout/html"

module Markout
  macro included
    {% raise "`Markout` is not a mixin; do not `include`" %}
  end

  extend self
end
