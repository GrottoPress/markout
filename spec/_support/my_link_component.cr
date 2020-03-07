struct MyLinkComponent < BaseComponent
  def initialize(label : String, url : String, **opts)
    render(label, url, **opts)
  end

  private def render(label : String, url : String, **opts) : Nil
    args = opts.merge({href: url})
    args = {class: "link"}.merge(args)

    a label, **args
  end
end
