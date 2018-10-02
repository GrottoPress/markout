require "./spec_helper"

describe Markout do
  describe "#doctype" do
    context "given an invalid doctype" do
      it "raises an exception" do
        expect_raises ArgumentError do
          markout { doctype "invalid" }.to_s
        end
      end
    end

    context "given an 'html_5' doctype" do
      it "returns valid html 5 doctype" do
        markout { doctype "html_5" }.to_s.should eq("<!DOCTYPE html>")
      end
    end

    context "given an 'html_4_01_strict' doctype" do
      it "returns valid html 4.01 strict doctype" do
        markout { doctype "html_4_01_strict" }.to_s.should eq(
          "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>"
        )
      end
    end

    context "given an 'html_4_01_transitional' doctype" do
      it "returns valid html 4.01 transitional doctype" do
        markout { doctype "html_4_01_transitional" }.to_s.should eq(
          "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>"
        )
      end
    end

    context "given an 'html_4_01_frameset' doctype" do
      it "returns valid html 4.01 frameset doctype" do
        markout { doctype "html_4_01_frameset" }.to_s.should eq(
          "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Frameset//EN' 'http://www.w3.org/TR/html4/frameset.dtd'>"
        )
      end
    end

    context "given an 'xhtml_1_0_strict' doctype" do
      it "returns valid xhtml 1.0 strict doctype" do
        markout { doctype "xhtml_1_0_strict" }.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
        )
      end
    end

    context "given an 'xhtml_1_0_transitional' doctype" do
      it "returns valid xhtml 1.0 transitional doctype" do
        markout { doctype "xhtml_1_0_transitional" }.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>"
        )
      end
    end

    context "given an 'xhtml_1_0_frameset' doctype" do
      it "returns valid xhtml 1.0 frameset doctype" do
        markout { doctype "xhtml_1_0_frameset" }.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Frameset//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'>"
        )
      end
    end

    context "given an 'xhtml_1_1' doctype" do
      it "returns valid xhtml 1.1 doctype" do
        markout { doctype "xhtml_1_1" }.to_s.should eq(
          "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>"
        )
      end
    end
  end

  describe "#text" do
    context "given an empty text" do
      it "returns empty text" do
        markout { text "" }.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns escaped text" do
        markout { text "<div id='div'>" }.to_s.should eq(
          "&lt;div id=&#39;div&#39;&gt;"
        )
      end
    end
  end

  describe "#raw" do
    context "given an empty text" do
      it "returns empty text" do
        markout { raw "" }.to_s.should eq("")
      end
    end

    context "given a text" do
      it "returns unmodified text" do
        markout { raw "<div id='div'>" }.to_s.should eq("<div id='div'>")
      end
    end
  end

  describe "#link" do
    context "called with block" do
      it "raises an exception" do
        expect_raises Exception do
          markout { link {} }.to_s
        end
      end
    end

    context "called without a block" do
      it "returns valid element" do
        markout { link rel: "stylesheet", href: "http://ab.c" }.to_s.should eq(
          "<link rel='stylesheet' href='http://ab.c' />"
        )
      end
    end
  end

  describe "#div" do
    context "called without a block" do
      it "raises an exception" do
        expect_raises Exception do
          markout { div id: "my-div" }.to_s
        end
      end
    end

    context "called with a block" do
      it "returns valid element" do
        markout { div id: "my-div" { text "hi" } }.to_s.should eq(
          "<div id='my-div'>hi</div>"
        )
      end
    end
  end

  describe "#p" do
    context "called with an invalid attribute" do
      it "returns valid element with sanitized attribute" do
        markout { p data_foo: "foo" { text "foo paragraph" } }.to_s.should eq(
          "<p data-foo='foo'>foo paragraph</p>"
        )
      end
    end
  end

  describe "#li" do
    context "called with an iterator" do
      it "returns as many valid elements" do
        markout do
          ul do
            3.times do |i|
              li { text "Number #{i + 1}" }
            end
          end
        end.to_s.should eq(
          "<ul><li>Number 1</li><li>Number 2</li><li>Number 3</li></ul>"
        )
      end
    end
  end
end
