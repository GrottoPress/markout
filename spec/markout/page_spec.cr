require "../spec_helper"

describe Markout::Page do
  describe "#to_s" do
    it "renders page markup accurately" do
      MyPage.new.to_s.should eq(
        <<-HTML
        <!DOCTYPE html>\
        <html lang='en'>\
          <head profile='http://ab.c'>\
            <meta charset='UTF-8'>\
            <title>Brrrr!</title>\
          </head>\
          <body class='my-body-class'>\
            <header id='header'>\
              <h1>My First Heading Level</h1>\
              <p>An awesome description</p>\
            </header>\
            <p>Hello from markout!</p>\
            <footer id='footer'>\
              <!-- I'm unescaped -->\
            </footer>\
          </body>\
        </html>
        HTML
      )
    end
  end
end
