struct MyPage < BasePage
  private def head_content(m : Markout) : Nil
    m.title &.text "Brrrr!"
  end

  private def body_content(m : Markout) : Nil
    m.p &.text "Hello from markout!"
  end
end
