require "./spec_helper"

describe Markout do
  it "renders XHTML 4.01 page correctly" do
    MyHtml401Page.new.to_s.should eq(
      <<-HTML
      <!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' \
        'http://www.w3.org/TR/html4/strict.dtd'>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8'>\
          <title>HTML 4.01</title>\
        </head>\
        <body class='my-body-class'>\
          <header id='header'>\
            <h1 class='heading'>My First Heading Level</h1>\
            <p class='description'>An awesome description</p>\
          </header>\
          <p>This is a HTML 4.01 page</p>\
          <MyApp title='My Awesome App' />\
          <footer id='footer'>\
            <!-- I'm unescaped -->\
          </footer>\
        </body>\
      </html>
      HTML
    )
  end

  it "renders XHTML 1.0 page correctly" do
    MyXhtml10Page.new.to_s.should eq(
      <<-HTML
      <!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 \
        Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8' />\
          <title>XHTML 1.0</title>\
        </head>\
        <body class='my-body-class'>\
          <header id='header'>\
            <h1 class='heading'>My First Heading Level</h1>\
            <p class='description'>An awesome description</p>\
          </header>\
          <p>This is a XHTML 1.0 page</p>\
          <div class='users-wrap'>\
            <ul class='users'>\
              <li class='user'>\
                <a class='user-link' href='#Kofi'>Kofi</a>\
              </li>\
              <li class='user'>\
                <a class='user-link' href='#Ama'>Ama</a>\
              </li>\
              <li class='user'>\
                <a class='user-link' href='#Nana'>Nana</a>\
              </li>\
            </ul>\
          </div>\
          <footer id='footer'>\
            <!-- I'm unescaped -->\
          </footer>\
        </body>\
      </html>
      HTML
    )
  end

  it "renders XHTML 1.1 page correctly" do
    MyXhtml11Page.new.to_s.should eq(
      <<-HTML
      <!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' \
        'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8' />\
          <title>XHTML 1.1</title>\
        </head>\
        <body class='my-body-class'>\
          <header id='header'>\
            <h1 class='heading'>My First Heading Level</h1>\
            <p class='description'>An awesome description</p>\
          </header>\
          <p>This is a XHTML 1.1 page</p>\
          <MyApp title='My Awesome App'>\
            <p>My app is the best.</p>\
          </MyApp>\
          <footer id='footer'>\
            <!-- I'm unescaped -->\
          </footer>\
        </body>\
      </html>
      HTML
    )
  end

  it "renders HTML 5 page accurately" do
    MyHtml5Page.new.to_s.should eq(
      <<-HTML
      <!DOCTYPE html>\
      <html lang='en'>\
        <head profile='http://ab.c'>\
          <meta charset='UTF-8'>\
          <title>HTML 5</title>\
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

  it "renders vue component accurately" do
    MyVueComponent.new.to_s.should eq(
      <<-HTML
      <template>\
        <div id='app'>\
          <span v-bind:foo.bar='message'>{{ message }}</span>\
          <button @click='myClickHandler'>Click me!</button>\
        </div>\
      </template>\
      <script>\
        const app = new Vue({\
          el: '#app',\
          data: {\
            message: 'Hello there!'\
          },\
          methods: {\
            myClickHandler: e => {\
              e.preventDefault()\
              /*...*/\
            }\
          }\
        })\
      </script>
      HTML
    )
  end
end
