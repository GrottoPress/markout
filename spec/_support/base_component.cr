abstract struct BaseComponent
  include Markout::HTML::Component

  private def html_version : Markout::HTML::Version
    Markout::XHTML_1_1
  end
end
