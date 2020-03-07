struct MyHtml5Page < BasePage
  def initialize(@title : String = "HTML 5")
  end

  private def head_content : Nil
    title @title
  end

  private def body_content : Nil
    p "This is a HTML 5 page"
  end
end
