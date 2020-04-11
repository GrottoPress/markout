module Markout::Amber::HTML
  def initialize(@controller : ::Amber::Controller::Base) : Nil
  end

  delegate :csrf_metatag,
    :csrf_tag,
    :csrf_token,
    :flash,
    :l,
    :t,
    to: @controller

  private def mount(
    component : Markout::HTML::Component.class,
    *args, **kwargs
  ) : Nil
    mount component.new(@controller, *args, **kwargs)
  end
end

module Markout::Amber::Controller
  protected def render(
    page : Markout::HTML::Page.class,
    *args,
    **kwargs
  ) : String
    page.new(self, *args, **kwargs).to_s
  end
end
