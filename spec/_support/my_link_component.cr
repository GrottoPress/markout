struct MyLinkComponent < BaseComponent
  def initialize(@label : String, @url : String, **opts) : Nil
    render_args(**opts)
  end

  private def render_args(**opts) : Nil
    args = opts.merge({href: @url})
    args = {class: "link"}.merge(args)

    a @label, **args
  end
end
