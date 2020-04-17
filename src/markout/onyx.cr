module Onyx::HTTP
  module Endpoint
    def view(__ klass : Onyx::HTTP::View.class, *args, **kwargs)
      view klass.new(*args, **kwargs)
    end
  end

  module View
    macro markout(
      page,
      *args,
      content_type = "text/html",
      accept = {"text/html"},
      **kwargs
    )
      {% if page.is_a?(Call)
        unless page.receiver.resolve <= Markout::HTML::Page
          raise "'#{page.receiver}' is not a page"
        end
      else
        unless page.resolve <= Markout::HTML::Page
          raise "'#{page}' is not a page"
        end
      end %}

      define_type_renderer(
        render_to_{{ content_type.underscore.gsub(/(?:-|\/)/, "_").id }},
        {{ content_type }},
        {{ accept }}
      ) do
        {% if page.is_a?(Call) %}
          io << {{ page }}
        {% else %}
          io << {{ page }}.new(
            {{ *args }}{{ args.empty? ? "".id : ", ".id }}{{ **kwargs }}
          )
        {% end %}
      end
    end
  end
end
