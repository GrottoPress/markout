struct MyXhtml10Page < BasePage
  private def html_version : HtmlVersion
    HtmlVersion::XHTML_1_0
  end

  private def head_content : Nil
    title "XHTML 1.0"
  end

  private def body_content : Nil
    p "This is a XHTML 1.0 page"

    div class: "users-wrap" do
      mount MyComponent, ["Kofi", "Ama", "Nana"]
    end
  end
end
