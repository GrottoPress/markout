struct MyHtml5Page < BasePage
  def initialize(@title : String = "HTML 5") : Nil
  end

  private def head_content : Nil
    title @title
  end

  private def body_content : Nil
    p "This is a HTML 5 page", "data-foo": "bar"

    div class: "user" do
      mount MyBlockComponent, "#kofi", class: "user-link" do |html|
        html.text("Kofi")
      end
    end
  end
end
