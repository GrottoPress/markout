struct MyLinkComponent < BaseComponent
  @y : Markout::HTML

  def initialize(@url : String, & : Proc(Markout::HTML, Nil))
    yield (m = Markout.html html_version)
    @y = m
  end

  private def render(m : Markout::HTML) : Nil
    m.a class: "link", href: @url do |m|
      m.raw @y
    end
  end
end
