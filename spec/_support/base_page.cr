abstract struct BasePage < Markout::HTML::Page
  #private def html_version : Markout::HTML::Version
  #  Markout::XHTML_1_1
  #end

  private def head_tag_attr : NamedTuple
    {profile: "http://ab.c"}
  end

  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head(m : Markout::HTML) : Nil
    m.meta charset: "UTF-8"
    head_content m
  end

  private def inside_body(m : Markout::HTML) : Nil
    m.header id: "header" do |m|
      m.h1 &.text "My First Heading Level"
      m.p &.text "An awesome description"
    end

    body_content m

    m.footer id: "footer" do |m|
      m.raw "<!-- I'm unescaped -->"
    end
  end

  private abstract def head_content(m : Markout::HTML) : Nil

  private abstract def body_content(m : Markout::HTML) : Nil
end
