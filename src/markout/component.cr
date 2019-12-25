abstract struct Markout::Component
  @m : Markout = Markout.new

  def to_s(io : IO) : Nil
    render @m
    io << @m
  end

  private abstract def render(m : Markout) : Nil
end
