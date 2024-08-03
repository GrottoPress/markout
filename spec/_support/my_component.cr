struct MyComponent < BaseComponent
  def initialize(@users : Array(String))
  end

  private def render : Nil
    ul class: "users" do
      @users.each do |user|
        li class: "user" do
          mount MyLinkComponent, user, "##{user}", class: "user-link"
        end
      end
    end
  end
end
