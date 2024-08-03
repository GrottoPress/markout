require "html"

require "./markout/version"
require "./markout/tags"
require "./markout/**"

module Markout
  @view = IO::Memory.new

  enum HtmlVersion
    HTML_4_01
    XHTML_1_0
    XHTML_1_1
    HTML_5
  end

  protected def doctype : Nil
    case html_version
    when .html_4_01?
      raw "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' \
        'http://www.w3.org/TR/html4/strict.dtd'>"
    when .xhtml_1_0?
      raw "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 \
        Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
    when .xhtml_1_1?
      raw "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' \
        'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>"
    else
      raw "<!DOCTYPE html>"
    end
  end

  {% for t in VOID_TAGS %}
    protected def {{ t.id }}(**attr) : Nil
      tag {{ t }}, **attr
    end
  {% end %}

  {% for t in NON_VOID_TAGS %}
    protected def {{ t.id }}(**attr) : Nil
      tag {{ t }}, **attr do end
    end

    protected def {{ t.id }}(__ label : String, **attr) : Nil
      tag {{ t }}, **attr do text(label) end
    end

    protected def {{ t.id }}(**attr, &b : Proc(Nil)) : Nil
      tag {{ t }}, **attr, &b
    end
  {% end %}

  protected def tag(__ name : Symbol, **attr) : Nil
    tag name.to_s, **attr
  end

  protected def tag(__ name : Symbol, **attr, &b : Proc(Nil)) : Nil
    tag name.to_s, **attr, &b
  end

  protected def tag(__ name : String, **attr) : Nil
    if jsx?(name) || xhtml?
      raw "<#{name}#{build_attrs(attr)} />"
    else
      raw "<#{name}#{build_attrs(attr)}>"
    end
  end

  protected def tag(__ name : String, **attr, & : Proc(Nil)) : Nil
    raw "<#{name}#{build_attrs(attr)}>"
    yield
    raw "</#{name}>"
  end

  private def mount(
    component : Component.class,
    *args,
    **kwargs,
    &b : Proc(Component, Nil)
  ) : Nil
    mount component.new(*args, **kwargs, &b)
  end

  private def mount(component : Component.class, *args, **kwargs) : Nil
    mount component.new(*args, **kwargs)
  end

  private def mount(component : Component) : Nil
    raw component
  end

  protected def text(text) : Nil
    raw esc(text)
  end

  protected def raw(text) : Nil
    @view << text.to_s
  end

  private def html_version : HtmlVersion
    HtmlVersion::HTML_5
  end

  private def build_attrs(attrs = NamedTuple.new) : String
    attr_str = attrs.map do |key, val|
      if val.nil?
        xhtml? ? "#{key}='#{esc(key)}'" : key
      else
        "#{key}='#{esc(val)}'"
      end
    end

    attr_str.empty? ? "" : " #{attr_str.join(' ')}"
  end

  private def esc(text) : String
    HTML.escape text.to_s
  end

  private def xhtml? : Bool
    html_version.to_s.starts_with? "XHTML_"
  end

  private def jsx?(name : String) : Bool
    name[0].uppercase?
  end
end
