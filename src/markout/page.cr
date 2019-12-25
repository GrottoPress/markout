abstract struct Markout::Page
  @m : Markout = Markout.new

  def to_s(io : IO) : Nil
    @m.doctype
    @m.html **html_tag_attr do |m|
      m.head **head_tag_attr do |m|
        inside_head m
      end

      m.body **body_tag_attr do |m|
        inside_body m
      end
    end

    io << @m
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

  private abstract def inside_head(m : Markout) : Nil

  private abstract def inside_body(m : Markout) : Nil
end
