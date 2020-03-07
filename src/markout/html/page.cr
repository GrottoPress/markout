module Markout::HTML::Page
  include HTML

  def to_s(io : IO) : Nil
    doctype

    html **html_tag_attr do
      head **head_tag_attr do
        inside_head
      end

      body **body_tag_attr do
        inside_body
      end
    end

    io << @view
  end

  private def html_tag_attr : NamedTuple
    {lang: "en"}
  end

  private def head_tag_attr : NamedTuple
    NamedTuple.new
  end

  private def body_tag_attr : NamedTuple
    NamedTuple.new
  end

  private def inside_head : Nil
  end

  private def inside_body : Nil
  end
end
