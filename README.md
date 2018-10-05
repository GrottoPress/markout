# Markout

**Markout** is an awesome Crystal DSL for HTML. Use **Markout** if you need:

- Type-safe HTML
- Automatically escaped attributes
- Accurate, valid syntax

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

m = markout do
  doctype "html_5"

  html lang: "en" do
    head do
      meta charset: "utf-8"
      title { text "Markout is awesome!" }
    end

    body class: "my-body-class", data_foo: "bar" do
      header id: "header" do
        h1 { text "Hello, world!" }
        p { text "Hello from markout :-)" }
      end

      div id: "content" do
        p { text "Markout is an awesome Crystal DSL for HTML." }

        ul class: "numbers" do
          3.times do |i|
            li { text "Number #{i + 1}" }
          end
        end
      end
    end
  end
end

# SEND OUTPUT TO CONSOLE

puts m # => <!DOCTYPE html><html lang='en'><head><meta charset='utf-8' /><title>Markout is awesome!</title></head><body class='my-body-class' data-foo='bar'><header id='header'><h1>Hello, world!</h1><p>Hello from markout :-)</p></header><div id='content'><p>Markout is an awesome Crystal DSL for HTML.</p><ul class='numbers'><li>Number 1</li><li>Number 2</li><li>Number 3</li></ul></div></body></html>

# OR, SERVE IT TO THE BROWSER

require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/html"
  context.response.print m
end

puts "Listening on http://#{server.bind_tcp 8080}"
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
abstract class BasePage < Markout::BaseTemplate
  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_body : Markout
    markout do
      header id: "header" do
        h1 { text "My First Heading Level" }
        p { text "An awesome description" }
      end

      raw self.content.to_s

      footer id: "footer" do
        raw "<!-- I'm unescaped -->"
      end
    end
  end

  private abstract def content : Markout
end

# Now, create a page
class MyFirstPage < BasePage
  private def inside_head : Markout
    markout { title { text "Brrrr!" } }
  end

  private def content : Markout
    markout { p { text "Hello from markout!" } }
  end
end

#puts MyFirstPage.new
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
