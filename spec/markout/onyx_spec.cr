require "onyx-http"

require "../spec_helper"
require "../../src/markout/onyx"

class MyOnyxEndpoint
  include Onyx::HTTP::Endpoint

  def call
    view MyOnyxPageClassView
  end
end

class MyOnyxPageClassView
  include Onyx::HTTP::View
  html MyHtml5Page, title: "My Onyx Page Class View"
end

class MyOnyxPageObjectView
  include Onyx::HTTP::View
  html MyHtml5Page.new(title: "My Onyx Page Object View")
end

describe Onyx::HTTP::Endpoint do
  describe "#view" do
    it "sets view" do
      request = HTTP::Request.new("GET", "/")
      response = HTTP::Server::Response.new(IO::Memory.new)
      context = HTTP::Server::Context.new(request, response)

      MyOnyxEndpoint.new(context).call

      context.response.view.should be_a(MyOnyxPageClassView)
    end
  end
end

describe Onyx::HTTP::View do
  describe ".html" do
    context "give a page class" do
      it "renders page to io" do
        memory = IO::Memory.new
        MyOnyxPageClassView.new.render_to_text_html(memory)

        memory.to_s.should eq(
          <<-HTML
          <!DOCTYPE html>\
          <html lang='en'>\
            <head profile='http://ab.c'>\
              <meta charset='UTF-8'>\
              <title>My Onyx Page Class View</title>\
            </head>\
            <body class='my-body-class'>\
              <header id='header'>\
                <h1 class='heading'>My First Heading Level</h1>\
                <p class='description'>An awesome description</p>\
              </header>\
              <p>This is a HTML 5 page</p>\
              <footer id='footer'>\
                <!-- I'm unescaped -->\
              </footer>\
            </body>\
          </html>
          HTML
        )
      end
    end

    context "give a page object" do
      it "renders page to io" do
        memory = IO::Memory.new
        MyOnyxPageObjectView.new.render_to_text_html(memory)

        memory.to_s.should eq(
          <<-HTML
          <!DOCTYPE html>\
          <html lang='en'>\
            <head profile='http://ab.c'>\
              <meta charset='UTF-8'>\
              <title>My Onyx Page Object View</title>\
            </head>\
            <body class='my-body-class'>\
              <header id='header'>\
                <h1 class='heading'>My First Heading Level</h1>\
                <p class='description'>An awesome description</p>\
              </header>\
              <p>This is a HTML 5 page</p>\
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
end
