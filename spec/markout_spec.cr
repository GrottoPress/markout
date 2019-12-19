require "./spec_helper"

describe Markout do
  describe "#doctype" do
    context "given an html 5 version" do
      it "returns valid html 5 doctype" do
        m = Markout.new :html_5
        m.doctype
        m.to_s.should eq("<!DOCTYPE html>")
      end
    end

    context "given an html 4.01 version" do
      it "returns valid html 4.01 strict doctype" do
        m = Markout.new :html_4_01
        m.doctype
        m.to_s.should eq(
          "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>"
        )
      end
    end

    context "given an xhtml 1.0 version" do
      it "returns valid xhtml 1.0 strict doctype" do
        m = Markout.new :xhtml_1_0
        m.doctype
        m.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
        )
      end
    end

    context "given an xhtml 1.1 version" do
      it "returns valid xhtml 1.1 doctype" do
        m = Markout.new :xhtml_1_1
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
        m = Markout.new
        m.text ""
        m.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns escaped text" do
        m = Markout.new
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
        m = Markout.new
        m.raw ""
        m.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns unmodified text" do
        m = Markout.new
        m.raw "<div id='div'>"
        m.to_s.should eq("<div id='div'>")
      end
    end
  end

  describe "#link" do
    context "called without a block" do
      it "returns valid 'link' element" do
        m = Markout.new
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
        m = Markout.new :xhtml_1_0
        m.meta name: "abc", href: "http://ab.c"
        m.to_s.should eq(
          "<meta name='abc' href='http://ab.c' />"
        )
      end
    end

    context "given an html 4 version" do
      it "returns valid html 4 'meta' element" do
        m = Markout.new :html_4_01
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
        m = Markout.new
        m.div id: "my-div"
        m.to_s.should eq("<div id='my-div'></div>")
      end
    end

    context "called with a block" do
      it "returns valid element" do
        m = Markout.new

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
        m = Markout.new

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
        m = Markout.new

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
end
