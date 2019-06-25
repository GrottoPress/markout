# Markout

**Markout** is an awesome Crystal DSL for HTML. Use **Markout** if you need:

- Type-safe HTML
- Automatically escaped attributes
- Accurate, valid syntax

Markout supports HTML 4, 5 and XHTML

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  markout:
    github: grottopress/markout
```

## Usage

```crystal
require "markout"

m = Markout.new :html_5

m.doctype

m.html lang: "en" do |m|
  m.head do |m|
    m.meta charset: "utf-8"
    m.title &.text "Markout is awesome!"
  end

  m.body class: "my-body-class", data_foo: "bar" do |m|
    m.header id: "header" do |m|
      m.h1 &.text "Hello, world!"
      m.p &.text "Hello from markout :-)"
    end

    m.div id: "content" do |m|
      m.p &.text "Markout is an awesome Crystal DSL for HTML."

      m.ul class: "numbers" do |m|
        3.times do |i|
          m.li &.text "Number #{i + 1}"
        end
      end
    end
  end
end

# SEND OUTPUT TO CONSOLE

puts m
# => <!DOCTYPE html>\
# => <html lang='en'>\
# =>   <head>\
# =>     <meta charset='utf-8'>\
# =>     <title>Markout is awesome!</title>\
# =>   </head>\
# =>   <body class='my-body-class' data-foo='bar'>\
# =>     <header id='header'>\
# =>       <h1>Hello, world!</h1>\
# =>       <p>Hello from markout :-)</p>\
# =>     </header>\
# =>     <div id='content'>\
# =>       <p>Markout is an awesome Crystal DSL for HTML.</p>\
# =>       <ul class='numbers'>\
# =>         <li>Number 1</li>\
# =>         <li>Number 2</li>\
# =>         <li>Number 3</li>\
# =>       </ul>\
# =>     </div>\
# =>   </body>\
# => </html>

# OR, SERVE IT TO THE BROWSER

require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/html"
  context.response.print m
end

puts "Listening on http://#{server.bind_tcp(8080)}"

server.listen

# Open your browser and visit 'http://localhost:8080' to see Markout in action
```

## Handy methods

Apart from calling regular HTML tags as methods, the following methods are available:

- `#text(text : String)`: Use this to escape text
- `#raw(text : String)`: Use this for unmodified text

## Working with templates

**Markout** comes with a base template, from which child templates can inherit, and override specific methods for their own use case:

```crystal
require "markout"

# Create your own base page
abstract class BasePage < Markout::Template::Base
  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head(m : Markout) : Nil
    m.meta charset: "UTF-8"
    head_content m
  end

  private def inside_body(m : Markout) : Nil
    m.header id: "header" do |m|
      m.h1 &.text "My First Heading Level"
      m.p &.text "An awesome description"
    end

    body_content m

    m.footer id: "footer" do |m|
      m.raw "<!-- I'm unescaped -->"
    end
  end

  private abstract def head_content(m : Markout) : Nil

  private abstract def body_content(m : Markout) : Nil
end

# Now, create a page
class MyFirstPage < BasePage
  private def head_content(m : Markout) : Nil
    m.title &.text "Brrrr!"
  end

  private def body_content(m : Markout) : Nil
    m.p &.text "Hello from markout!"
  end
end

m = Markout.new :xhtml_1_1
my_first_page = MyFirstPage.new m

#puts my_first_page
```

## Alternatives

Check out the following, if **Markout** does not fit your needs:

- [crystal-lang/html_builder](https://github.com/crystal-lang/html_builder)
- [Lucky framework](https://luckyframework.org/guides/rendering-html/) comes with an in-built html builder.

## Security

Kindly report suspected security vulnerabilities in private, via contact details outlined in this repository's `.security.txt` file.

## Contributing

1. Fork it (<https://github.com/grottopress/markout/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@GrottoPress](https://github.com/grottopress) (creator, maintainer)
- [@akadusei](https://github.com/akadusei)
