abstract struct Markout::HTML::Component
  def to_s(io : IO) : Nil
    m = HTML.new html_version
    render m
    io << m
  end

  private def html_version : Version
    Version::HTML_5
  end

  private abstract def render(m : HTML) : Nil
end
