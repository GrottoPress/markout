require "./spec_helper"

describe Markout::HTML do
  describe "#doctype" do
    context "given an html 5 version" do
      it "returns valid html 5 doctype" do
        m = Markout.html :html_5
        m.doctype
        m.to_s.should eq("<!DOCTYPE html>")
      end
    end

    context "given an html 4.01 version" do
      it "returns valid html 4.01 strict doctype" do
        m = Markout.html :html_4_01
        m.doctype
        m.to_s.should eq(
          "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>"
        )
      end
    end

    context "given an xhtml 1.0 version" do
      it "returns valid xhtml 1.0 strict doctype" do
        m = Markout.html :xhtml_1_0
        m.doctype
        m.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
        )
      end
    end

    context "given an xhtml 1.1 version" do
      it "returns valid xhtml 1.1 doctype" do
        m = Markout.html :xhtml_1_1
        m.doctype
        m.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>"
        )
      end
    end
  end

  describe "#text" do
    context "given an empty text" do
      it "returns empty text" do
        m = Markout.html
        m.text ""
        m.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns escaped text" do
        m = Markout.html
        m.text "<div id='div'>"
        m.to_s.should eq(
          "&lt;div id=&#39;div&#39;&gt;"
        )
      end
    end
  end

  describe "#raw" do
    context "given an empty text" do
      it "returns empty text" do
        m = Markout.html
        m.raw ""
        m.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns unmodified text" do
        m = Markout.html
        m.raw "<div id='div'>"
        m.to_s.should eq("<div id='div'>")
      end
    end
  end

  describe "#link" do
    context "called without a block" do
      it "returns valid 'link' element" do
        m = Markout.html
        m.link rel: "stylesheet", href: "http://ab.c"
        m.to_s.should eq(
          "<link rel='stylesheet' href='http://ab.c'>"
        )
      end
    end
  end

  describe "#meta" do
    context "given an xhtml version" do
      it "returns valid xhtml 'meta' element" do
        m = Markout.html :xhtml_1_0
        m.meta name: "abc", href: "http://ab.c"
        m.to_s.should eq(
          "<meta name='abc' href='http://ab.c' />"
        )
      end
    end

    context "given an html 4 version" do
      it "returns valid html 4 'meta' element" do
        m = Markout.html :html_4_01
        m.meta name: "abc", href: "http://ab.c"
        m.to_s.should eq(
          "<meta name='abc' href='http://ab.c'>"
        )
      end
    end
  end

  describe "#div" do
    context "called without a block" do
      it "returns a valid, closed 'div' element" do
        m = Markout.html
        m.div id: "my-div"
        m.to_s.should eq("<div id='my-div'></div>")
      end
    end

    context "called with a block" do
      it "returns valid element" do
        m = Markout.html

        m.div id: "my-div" do |m|
          m.text "hi"
        end

        m.to_s.should eq(
          "<div id='my-div'>hi</div>"
        )
      end
    end
  end

  describe "#p" do
    context "called with an invalid attribute" do
      it "returns valid element with sanitized attribute" do
        m = Markout.html

        m.p data_foo: "foo" do |m|
          m.text "foo paragraph"
        end

        m.to_s.should eq(
          "<p data-foo='foo'>foo paragraph</p>"
        )
      end
    end
  end

  describe "#li" do
    context "called with an iterator" do
      it "returns as many valid elements" do
        m = Markout.html

        m.ul do |m|
          3.times do |i|
            m.li &.text "Number #{i + 1}"
          end
        end

        m.to_s.should eq(
          "<ul><li>Number 1</li><li>Number 2</li><li>Number 3</li></ul>"
        )
      end
    end
  end

  describe "#input" do
    context "called with a `nil` attribute value" do
      it "returns valid element with a valueless boolean attribute" do
        m = Markout.html

        m.input class: "foo", disabled: nil, Type: "submit"

        m.to_s.should eq("<input class='foo' disabled type='submit'>")
      end
    end

    context "called with a `nil` attribute value" do
      it "returns valid element with a valid xhtml boolean attribute" do
        m = Markout.html :xhtml_1_1

        m.input disabled: nil, type: "submit"

        m.to_s.should eq("<input disabled='disabled' type='submit' />")
      end
    end

    context "called with an empty attribute value" do
      it "returns valid element with an empty attribute value" do
        m = Markout.html :html_4_01

        m.input class: "foo", DISABLED: "", type: "submit"

        m.to_s.should eq("<input class='foo' disabled='' type='submit'>")
      end
    end
  end

  describe "#tag" do
    context "called without a block" do
      it "returns a custom HTML tag" do
        m = Markout.html :html_4_01

        m.tag :MyApp, title: "My Awesome App"

        m.to_s.should eq(
          "<MyApp title='My Awesome App' />"
        )
      end
    end

    context "called with a block" do
      it "returns a custom HTML tag with content" do
        m = Markout.html

        m.tag "MyApp", title: "My Awesome App" do |m|
          m.p &.text "My app is the best."
        end

        m.to_s.should eq(
          "<MyApp title='My Awesome App'><p>My app is the best.</p></MyApp>"
        )
      end
    end
  end

  describe "#mount" do
    context "called without a block" do
      it "renders component markup accurately" do
        users = [{"name" => "Kofi"}, {"name" => "Ama"}, {"name" => "Nana"}]
        m = Markout.html :xhtml_1_1

        m.div class: "users-wrap" do |m|
          m.mount MyComponent, users
        end

        m.to_s.should eq(
          <<-HTML
          <div class='users-wrap'>\
            <ul class='users'>\
              <li class='user'>Kofi</li>\
              <li class='user'>Ama</li>\
              <li class='user'>Nana</li>\
            </ul>\
          </div>
          HTML
        )
      end
    end

    context "called with a block" do
      it "renders component markup accurately" do
        m = Markout.html :xhtml_1_1

        m.div class: "link-wrap" do |m|
          m.mount MyLinkComponent, "http://ab.c" do |m|
            m.img src: "abc.img"
          end
        end

        m.to_s.should eq(
          <<-HTML
          <div class='link-wrap'>\
            <a class='link' href='http://ab.c'>\
              <img src='abc.img' />\
            </a>\
          </div>
          HTML
        )
      end
    end

    context "called with named arguments" do
      it "renders component markup accurately" do
        m = Markout.html :xhtml_1_1

        m.div class: "link-wrap" do |m|
          m.mount MyLinkComponent, "http://ab.c",
          class: "x-link", id: "my-link" do |m|
            m.img src: "abc.img"
          end
        end

        m.to_s.should eq(
          <<-HTML
          <div class='link-wrap'>\
            <a class='x-link' id='my-link' href='http://ab.c'>\
              <img src='abc.img' />\
            </a>\
          </div>
          HTML
        )
      end
    end
  end
end
