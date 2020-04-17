require "amber"

require "../spec_helper"
require "../../src/markout/amber"

struct MyAmberComponent < BaseComponent
  include Markout::Amber::HTML

  def initialize(@controller : Amber::Controller::Base)
    render
  end

  private def render
    small "My Amber Component"
  end
end

struct MyAmberPage < BasePage
  include Markout::Amber::HTML

  def initialize(@controller : Amber::Controller::Base, @title : String) : Nil
  end

  private def head_content : Nil
    title @title
  end

  private def body_content : Nil
    flash.each do |key, value|
      p value
    end

    p "This is a Amber page"

    mount MyAmberComponent
  end
end

class MyAmberController < Amber::Controller::Base
  def index
    flash[:hello] = "Hello amber"
    markout MyAmberPage, "Amber Page"
  end
end

describe MyAmberController do
  describe "#index" do
    it "renders page correctly" do
      request = HTTP::Request.new("GET", "/")
      response = HTTP::Server::Response.new(IO::Memory.new)
      context = HTTP::Server::Context.new(request, response)

      MyAmberController.new(context).index.should eq(
        <<-HTML
        <!DOCTYPE html>\
        <html lang='en'>\
          <head profile='http://ab.c'>\
            <meta charset='UTF-8'>\
            <title>Amber Page</title>\
          </head>\
          <body class='my-body-class'>\
            <header id='header'>\
              <h1 class='heading'>My First Heading Level</h1>\
              <p class='description'>An awesome description</p>\
            </header>\
            <p>Hello amber</p>\
            <p>This is a Amber page</p>\
            <small>My Amber Component</small>\
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
