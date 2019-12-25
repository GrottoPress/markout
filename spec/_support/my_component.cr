struct MyComponent < BaseComponent
  def initialize(@users : Array(Hash(String, String)))
  end

  private def render(m : Markout) : Nil
    m.ul class: "users" do |m|
      @users.each do |user|
        m.li class: "user" do |m|
          m.text user["name"]
        end
      end
    end
  end
end
