struct MyLinkComponent < BaseComponent
  @r : String

  def initialize(@url : String, **opts, &b : Proc(Markout::HTML, Nil))
    @r = render(**opts, &b)
  end

  private def render(m : Markout::HTML) : Nil
    m.raw @r
  end

  private def render(**opts, & : Proc(Markout::HTML, Nil)) : String
    yield (a = Markout.html html_version)
    args = opts.merge({href: @url})
    args = {class: "link"}.merge args
    m = Markout.html html_version
    m.a **args do |m|
      m.raw(a)
    end
    m.to_s
  end
end
