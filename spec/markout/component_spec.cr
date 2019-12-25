require "../spec_helper"

describe Markout::Component do
  describe "#to_s" do
    it "renders component markup accurately" do
      users = [{"name" => "Kofi"}, {"name" => "Ama"}, {"name" => "Nana"}]

      MyComponent.new(users).to_s.should eq(
        <<-HTML
        <ul class='users'>\
          <li class='user'>Kofi</li>\
          <li class='user'>Ama</li>\
          <li class='user'>Nana</li>\
        </ul>
        HTML
      )
    end
  end
end
