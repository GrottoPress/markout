struct MyBlockComponent < BaseComponent
  def initialize(url : String, **opts, &b : Proc(Component, Nil))
    render(url, **opts, &b)
  end

  private def render(url : String, **opts, &b : Proc(Component, Nil))
    args = opts.merge({href: url})
    args = {class: "link"}.merge(args)

    a **args do b.call(self) end
  end
end
