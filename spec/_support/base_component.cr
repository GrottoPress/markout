abstract struct BaseComponent
  include Markout::Component

  private def version : Version
    Version::XHTML_1_0
  end
end
