require "html"
require "./tags"

class Markout
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  @nodes : Array(String) = [] of String

  private getter? xhtml : Bool

  enum Version
    HTML_4_01
    XHTML_1_0
    XHTML_1_1
    HTML_5
  end

  def initialize(@version : Version = :html_5)
    @xhtml = @version.to_s.starts_with? "XHTML_"
  end

  def to_s(io : IO) : Nil
    io << @nodes.join
  end

  def doctype : Nil
    case @version
    when .html_4_01?
      @nodes << "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' \
        'http://www.w3.org/TR/html4/strict.dtd'>"
    when .xhtml_1_0?
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 \
        Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
    when .xhtml_1_1?
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' \
        'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>"
    else
      @nodes << "<!DOCTYPE html>"
    end
  end

  {% for t in VOID_TAGS %}
    def {{ t.id }}(**attr) : Nil
      tag {{ t }}, **attr
    end
  {% end %}

  {% for t in NON_VOID_TAGS %}
    def {{ t.id }}(**attr) : Nil
      tag {{ t }}, **attr do end
    end

    def {{ t.id }}(**attr, &b : Proc(self, Nil)) : Nil
      tag {{ t }}, **attr, &b
    end
  {% end %}

  def tag(__ name : Symbol, **attr) : Nil
    if component?(name) || xhtml?
      @nodes << "<#{name}#{build_attrs(attr)} />"
    else
      @nodes << "<#{name}#{build_attrs(attr)}>"
    end
  end

  def tag(__ name : Symbol, **attr, & : Proc(self, Nil)) : Nil
    yield (m = self.class.new @version)
    @nodes << "<#{name}#{build_attrs(attr)}>#{m}</#{name}>"
  end

  def text(text : String) : Nil
    @nodes << esc text
  end

  def raw(text : String) : Nil
    @nodes << text
  end

  private def component?(name : Symbol) : Bool
    name.to_s[0].uppercase?
  end

  private def build_attrs(attrs : NamedTuple = NamedTuple.new) : String
    attr_str = attrs.map do |key, val|
      "#{key.to_s.downcase.gsub(/[^a-zA-Z0-9\-]/, '-')}='#{esc(val)}'"
    end

    attr_str.empty? ? "" : " #{attr_str.join(' ')}"
  end

  private def esc(text : String) : String
    HTML.escape text
  end
end

require "./markout/template/base"
