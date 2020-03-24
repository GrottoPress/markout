module Markout::Amber::HTML
  def initialize(@controller : ::Amber::Controller::Base) : Nil
  end

  forward_missing_to @controller

  private def mount(
    component : Markout::HTML::Component.class,
    *args, **kwargs
  ) : Nil
    mount component.new(@controller, *args, **kwargs)
  end
end

module Markout::Amber::Controller
  protected def render(
    __ page : Markout::HTML::Page.class,
    *args,
    **kwargs
  ) : String
    self.render page.new(self, *args, **kwargs)
  end

  protected def render(page : Markout::HTML::Page) : String
    page.to_s
  end
end
