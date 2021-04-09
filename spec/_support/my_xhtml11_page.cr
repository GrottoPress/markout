struct MyXhtml11Page < BasePage
  private def html_version : HtmlVersion
    HtmlVersion::XHTML_1_1
  end

  private def head_content : Nil
    title "XHTML 1.1"
  end

  private def body_content : Nil
    p "This is a XHTML 1.1 page"

    tag :MyApp, title: "My Awesome App" do
      p "My app is the best."
    end
  end
end
