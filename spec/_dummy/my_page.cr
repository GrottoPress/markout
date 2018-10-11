class MyPage < BasePage
  private def head_content : Markout
    markout { title { text "Brrrr!" } }
  end

  private def body_content : Markout
    markout { p { text "Hello from markout!" } }
  end
end
