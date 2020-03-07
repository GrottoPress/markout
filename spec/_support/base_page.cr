abstract struct BasePage
  include Markout::HTML::Page

  private def head_tag_attr : NamedTuple
    {profile: "http://ab.c"}
  end

  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head : Nil
    meta charset: "UTF-8"
    head_content
  end

  private def inside_body : Nil
    header id: "header" do
      h1 "My First Heading Level", class: "heading"
      p "An awesome description", class: "description"
    end

    body_content

    footer id: "footer" do
      raw "<!-- I'm unescaped -->"
    end
  end

  private def head_content : Nil
  end

  private def body_content : Nil
  end
end
