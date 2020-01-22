struct MyPage < BasePage
  def initialize(@title : String = "Brrrr!")
  end

  private def head_content(m : Markout::HTML) : Nil
    m.title &.text @title
  end

  private def body_content(m : Markout::HTML) : Nil
    m.p &.text "Hello from markout!"
  end
end
