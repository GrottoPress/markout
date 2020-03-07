struct MyComponent < BaseComponent
  def initialize(@users : Array(String))
    render
  end

  private def render : Nil
    ul class: "users" do
      @users.each do |user|
        li class: "user" do
          mount MyLinkComponent, user, "##{user}", class: "user-link"
          # a user, class: "user-link", href: "##{user}"
        end
      end
    end
  end
end
