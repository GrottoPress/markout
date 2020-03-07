abstract struct BaseComponent
  include Markout::HTML::Component

  private def version : Version
    Version::XHTML_1_0
  end
end
