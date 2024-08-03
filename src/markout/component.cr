module Markout::Component
  include Markout

  def to_s(io : IO) : Nil
    render
    io << @view
  end

  private def render : Nil
  end
end
