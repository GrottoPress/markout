require "quartz_mailer"

require "../spec_helper"
require "../../src/markout/renderer"

class MyMailer < Quartz::Composer
  include Markout::Renderer

  def initialize
    text markout(MyHtml5Page, "Text Email")
    html markout(MyHtml5Page, "HTML Email")
  end

  def message
    @message
  end
end

describe MyMailer do
  it "renders markout text email correctly" do
    MyMailer.new.message._text.should eq(
      <<-HTML
      <!DOCTYPE html>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8'>\
          <title>Text Email</title>\
        </head>\
        <body class='my-body-class'>\
          <header id='header'>\
            <h1 class='heading'>My First Heading Level</h1>\
            <p class='description'>An awesome description</p>\
          </header>\
          <p data-foo='bar'>This is a HTML 5 page</p>\
          <div class='user'>\
            <a class='user-link' href='#kofi'>Kofi</a>\
          </div>\
          <footer id='footer'>\
            <!-- I'm unescaped -->\
          </footer>\
        </body>\
      </html>
      HTML
    )
  end

  it "renders markout HTML email correctly" do
    MyMailer.new.message._html.should eq(
      <<-HTML
      <!DOCTYPE html>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8'>\
          <title>HTML Email</title>\
        </head>\
        <body class='my-body-class'>\
          <header id='header'>\
            <h1 class='heading'>My First Heading Level</h1>\
            <p class='description'>An awesome description</p>\
          </header>\
          <p data-foo='bar'>This is a HTML 5 page</p>\
          <div class='user'>\
            <a class='user-link' href='#kofi'>Kofi</a>\
          </div>\
          <footer id='footer'>\
            <!-- I'm unescaped -->\
          </footer>\
        </body>\
      </html>
      HTML
    )
  end
end
