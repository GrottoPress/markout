module Markout::HTML::Component
  include HTML

  def to_s(io : IO) : Nil
    io << @view
  end
end
