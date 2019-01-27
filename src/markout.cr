require "html"
require "./tags"

class Markout
  @nodes = [] of String

  def initialize(@version : String = "html_5")
    validate_doctype
  end

  def to_s(io : IO) : Nil
    io << @nodes.join
  end

  def doctype : Nil
    case @version
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
    else "html_5"
      @nodes << "<!DOCTYPE html>"
    end
  end

  {% for tag in VOID_TAGS %}
    def {{ tag.id }}(**attr) : Nil
      if @version.starts_with? "xhtml_"
        @nodes << "<{{ tag.id }}#{build_attrs(attr)} />"
      else
        @nodes << "<{{ tag.id }}#{build_attrs(attr)}>"
      end
    end
  {% end %}

  {% for tag in NON_VOID_TAGS %}
    def {{ tag.id }}(**attr) : Nil
      @nodes << "<{{ tag.id }}#{build_attrs(attr)}></{{ tag.id }}>"
    end

    def {{ tag.id }}(**attr) : Nil
      yield (m = self.class.new @version)
      @nodes << "<{{ tag.id }}#{build_attrs(attr)}>#{m}</{{ tag.id }}>"
    end
  {% end %}

  def text(text : String) : Nil
    @nodes << esc text
  end

  def raw(text : String) : Nil
    @nodes << text
  end

  private def validate_doctype
    doctypes = {
      "html_5",
      "html_4_01_strict",
      "html_4_01_transitional",
      "html_4_01_frameset",
      "xhtml_1_0_strict",
      "xhtml_1_0_transitional",
      "xhtml_1_0_frameset",
      "xhtml_1_1",
      "html_5"
    }

    unless doctypes.includes? @version
      raise ArgumentError.new "Doctype invalid!"
    end
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

require "./markout/base_template"
