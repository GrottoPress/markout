abstract struct Markout::Component
  def to_s(io : IO) : Nil
    m = Markout.new html_version
    render m
    io << m
  end

  private def html_version : Version
    Version::HTML_5
  end

  private abstract def render(m : Markout) : Nil
end
