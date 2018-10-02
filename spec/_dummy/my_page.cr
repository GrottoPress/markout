class MyPage < BasePage
  private def inside_head : Markout
    markout { title { text "Brrrr!" } }
  end

  private def content : Markout
    markout { p { text "Hello from markout!" } }
  end
end
