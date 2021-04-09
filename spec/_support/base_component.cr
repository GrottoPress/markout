abstract struct BaseComponent
  include Markout::Component

  private def html_version : HtmlVersion
    HtmlVersion::XHTML_1_0
  end
end
