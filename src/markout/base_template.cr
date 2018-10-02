abstract class Markout::BaseTemplate
  def to_s(io : IO) : Nil
    io << doctype
    io << markout do
      html **html_tag_attr do
        head **head_tag_attr do
          meta charset: charset
          raw self.inside_head.to_s
        end

        body **body_tag_attr do
          raw self.inside_body.to_s
        end
      end
    end
  end

  private def doctype : Markout
    markout { doctype "html_5" }
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

  private abstract def inside_head : Markout

  private abstract def inside_body : Markout

  private def charset : String
    "UTF-8"
  end
end
