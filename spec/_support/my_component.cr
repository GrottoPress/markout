struct MyComponent < BaseComponent
  def initialize(users : Array(String)) : Nil
    render(users)
  end

  private def render(users : Array(String)) : Nil
    ul class: "users" do
      users.each do |user|
        li class: "user" do
          mount MyLinkComponent, user, "##{user}", class: "user-link"
          # a user, class: "user-link", href: "##{user}"
        end
      end
    end
  end
end
