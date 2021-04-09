module Markout::Component
  include Markout

  def to_s(io : IO) : Nil
    io << @view
  end
end
