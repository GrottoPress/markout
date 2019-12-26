require "html"

require "./markout/version"
require "./markout/html/tags"
require "./markout/html"
require "./markout/html/**"

module Markout
  macro included
    {% raise "`Markout` is not a mixin; do not `include`" %}
  end

  extend self

  HTML_4_01 = HTML::Version::HTML_4_01
  XHTML_1_0 = HTML::Version::XHTML_1_0
  XHTML_1_1 = HTML::Version::XHTML_1_1
  HTML_5 = HTML::Version::HTML_5

  def html(version : HTML::Version = :html_5) : HTML
    HTML.new version
  end
end
