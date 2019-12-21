abstract struct BasePage < Markout::Page
  private def head_tag_attr : NamedTuple
    {profile: "http://ab.c"}
  end

  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head(m : Markout) : Nil
    m.meta charset: "UTF-8"
    head_content m
  end

  private def inside_body(m : Markout) : Nil
    m.header id: "header" do |m|
      m.h1 &.text "My First Heading Level"
      m.p &.text "An awesome description"
    end

    body_content m

    m.footer id: "footer" do |m|
      m.raw "<!-- I'm unescaped -->"
    end
  end

  private abstract def head_content(m : Markout) : Nil

  private abstract def body_content(m : Markout) : Nil
end
