module Markout::Renderer
  private def markout(
    page : Markout::HTML::Page.class,
    *args,
    **kwargs
  ) : String
    page.new(*args, **kwargs).to_s
  end
end
