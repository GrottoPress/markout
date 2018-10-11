abstract class BasePage < Markout::BaseTemplate
  private def head_tag_attr : NamedTuple
    {profile: "http://ab.c"}
  end

  private def body_tag_attr
    {class: "my-body-class"}
  end

  private def inside_head : Markout
    markout do
      meta charset: "UTF-8"
      raw self.head_content.to_s
    end
  end

  private def inside_body : Markout
    markout do
      header id: "header" do
        h1 { text "My First Heading Level" }
        p { text "An awesome description" }
      end

      raw self.body_content.to_s

      footer id: "footer" do
        raw "<!-- I'm unescaped -->"
      end
    end
  end

  private abstract def head_content : Markout

  private abstract def body_content : Markout
end
