struct MyBlockComponent < BaseComponent
  def initialize(@url : String, @class : String, &@block : Proc(Component, Nil))
  end

  private def render : Nil
    a href: @url, class: @class do
      @block.call(self)
    end
  end
end
