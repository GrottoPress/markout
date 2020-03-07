struct MyHtml401Page < BasePage
  private def version : Version
    Version::HTML_4_01
  end

  private def head_content : Nil
    title "HTML 4.01"
  end

  private def body_content : Nil
    p "This is a HTML 4.01 page"

    tag :MyApp, title: "My Awesome App"
  end
end
