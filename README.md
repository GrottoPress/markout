# Markout

**Markout** is an awesome Crystal DSL for HTML. It is a great alternative to template engines.

Use **Markout** if you need:

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

m = Markout.html :html_5

m.doctype

m.html lang: "en" do |m|
  m.head do |m|
    m.meta charset: "utf-8"
    m.title &.text "Markout is awesome!"
    m.link boolean_attribute: nil, rel: "stylesheet", href: "/style.css"
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
# =>     <link boolean-attribute rel='stylesheet' href='/style.css'>
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

### Custom Tags

You may define arbitrary tags with the `#tag` method. This is particularly useful for rendering JSX or similar.

Example:

```crystal
m = Markout.html

m.tag :MyApp, title: "My Awesome App" do |m|
  m.p &.text "My app is the best."
end

puts m
# => <MyApp title='My Awesome App'>\
# =>   <p>My app is the best.</p>\
# => </MyApp>
```

### Page templates

With **Markout**, pages are created using regular Crystal structs. **Markout** comes with a base page, which child pages can inherit, and override specific methods for their own use case:

```crystal
require "markout"

# Create your own base page
abstract struct BasePage < Markout::HTML::Page
  # Use this to change HTML version
  #private def html_version : Markout::HTML::Version
  #  Markout::XHTML_1_1
  #end

  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head(m : Markout::HTML) : Nil
    m.meta charset: "UTF-8"
    head_content m
  end

  private def inside_body(m : Markout::HTML) : Nil
    m.header id: "header" do |m|
      m.h1 &.text "My First Heading Level"
      m.p &.text "An awesome description"
    end

    m.main id: main do |m|
      body_content m
    end

    m.footer id: "footer" do |m|
      m.raw "<!-- I'm unescaped -->"
    end
  end

  private abstract def head_content(m : Markout::HTML) : Nil

  private abstract def body_content(m : Markout::HTML) : Nil
end

# Now, create a page
struct MyFirstPage < BasePage
  private def head_content(m : Markout::HTML) : Nil
    m.title &.text "Brrrr!"
  end

  private def body_content(m : Markout::HTML) : Nil
    m.p &.text "Hello from markout!"
  end
end

#puts MyFirstPage.new
```

### Components

You may extract out shared elements that do not exactly fit into the page inheritance structure as components, and mount them in your pages.

```crystal
require "markout"

# Create your own base component
abstract struct BaseComponent < Markout::HTML::Component
  # Use this to change HTML version
  #private def html_version : Markout::HTML::Version
  #  Markout::XHTML_1_1
  #end
end

# Create the component
struct MyFirstComponent < BaseComponent
  def initialize(@users : Array(Hash(String, String)))
  end

  # Define the required `#render` method
  private def render(m : Markout::HTML) : Nil
    m.ul class: "users" do |m|
      @users.each do |user|
        m.li class: "user" do |m|
          m.text user["name"]
        end
      end
    end
  end
end

# Mount the component (with `#mount`)
struct MySecondPage < BasePage
  def initialize(@users : Array(Hash(String, String)))
  end

  private def head_content(m : Markout::HTML) : Nil
    m.title &.text "Component test"
  end

  private def body_content(m : Markout::HTML) : Nil
    m.div class: "users-wrap" do |m|
      m.mount MyFirstComponent, @users # Or `m.mount MyFirstComponent.new(@users)`
    end
  end
end

#users = [{"name" => "Kofi"}, {"name" => "Ama"}, {"name" => "Nana"}]
#puts MySecondPage.new(users)
```

### Handy methods

Apart from calling regular HTML tags as methods, the following methods are available:

- `#text(text : String)`: Use this to escape text
- `#raw(text : String)`: Use this add unescaped text

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
