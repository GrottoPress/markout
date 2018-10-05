require "html"
require "./tags"

class Markout
  @nodes = [] of String

  def to_s(io : IO) : Nil
    io << @nodes.join
  end

  private def doctype(version : String = "html_5") : Nil
    case version
    when "html_4_01_strict"
      @nodes << "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>"
    when "html_4_01_transitional"
      @nodes << "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>"
    when "html_4_01_frameset"
      @nodes << "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Frameset//EN' 'http://www.w3.org/TR/html4/frameset.dtd'>"
    when "xhtml_1_0_strict"
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
    when "xhtml_1_0_transitional"
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>"
    when "xhtml_1_0_frameset"
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Frameset//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'>"
    when "xhtml_1_1"
      @nodes << "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>"
    when "html_5"
      @nodes << "<!DOCTYPE html>"
    else
      raise ArgumentError.new "Doctype invalid!"
    end
  end

  {% for tag in TAGS %}
    private def {{tag.id}}(**attr) : Nil
      raise "'{{tag.id}}' is a void tag!" if VOID_TAGS.includes? {{tag}}

      with (m = Markout.new) yield
      @nodes << "<{{tag.id}}#{build_attrs(attr)}>#{m}</{{tag.id}}>"
    end

    private def {{tag.id}}(**attr) : Nil
      if NON_VOID_TAGS.includes? {{tag}}
        @nodes << "<{{tag.id}}#{build_attrs(attr)}></{{tag.id}}>"
      else
        @nodes << "<{{tag.id}}#{build_attrs(attr)} />"
      end
    end
  {% end %}

  private def text(text : String) : Nil
    @nodes << esc text
  end

  private def raw(text : String) : Nil
    @nodes << text
  end

  private def build_attrs(attrs : NamedTuple = NamedTuple.new) : String
    attr_str = attrs.map do |key, val|
      "#{key.to_s.gsub(/[^a-zA-Z0-9\-]/, '-')}='#{esc(val)}'"
    end

    attr_str.empty? ? "" : " #{attr_str.join(' ')}"
  end

  private def esc(text : String) : String
    HTML.escape text
  end
end

require "./helper"
require "./markout/base_template"
