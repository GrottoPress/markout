# Markout

**Markout** is an awesome Crystal DSL for HTML. It enables calling regular HTML tags as methods to generate HTML.

**Markout** ensures type-safe HTML with valid syntax, and automatically escapes attribute values.

**Markout** supports HTML 4 and 5, and XHTML.

### Examples:

```crystal
p "A paragraph"
# => <p>A paragraph</p>

p do
  text "A paragraph"
end
# => <p>A paragraph</p>

h1 "A first-level heading", class: "heading"
# => <h1 class='heading'>A first-level heading</h1>

h1 class: "heading" do
  text "A first-level heading"
end
# => <h1 class='heading'>A first-level heading</h1>

ul id: "a-wrapper", class: "list-wrap" do
  ["aa", "bb", "cc"].each do |x|
    li x, class: "list-item"
  end
end
# => <ul id='a-wrapper' class='list-wrap'>
#      <li class='list-item'>aa</li>
#      <li class='list-item'>bb</li>
#      <li class='list-item'>cc</li>
#    </ul>

input type: "checkbox", checked: nil
# => HTML 4, 5: <input type='checkbox' checked>
# => XHTML: <input type='checkbox' checked='checked' />
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  markout:
    github: grottopress/markout
```

## Usage

### Pages

With **Markout**, pages are created using regular Crystal structs and classes. **Markout** comes with a page mixin, which child pages can `include`, and override specific methods for their own use case:

```crystal
require "markout/html"

# Create your own base page
abstract struct BasePage
  # Include the page mixin
  include Markout::HTML::Page

  # Set HTML version
  #
  # Versions:
  #   `Version::HTML_5` (default)
  #   `Version::XHTML_1_1`
  #   `Version::XHTML_1_0`
  #   `Version::HTML_4_01`
  #private def version : Version
  #  Version::XHTML_1_1
  #end

  private def body_tag_attr : NamedTuple
    {class: "my-body-class"}
  end

  private def inside_head : Nil
    meta charset: "UTF-8"
    head_content
  end

  private def inside_body : Nil
    header id: "header" do
      h1 "My First Heading Level", class: "heading"
      p "An awesome description", class: "description"
    end

    main id: main do
      body_content
    end

    footer id: "footer" do
      raw "<!-- I'm unescaped -->"
    end
  end

  private def head_content : Nil
  end

  private def body_content : Nil
  end
end

# Now, create a page
struct MyFirstPage < BasePage
  private def head_content : Nil
    title "My First Page"
  end

  private def body_content : Nil
    p "Hello from Markout!"
  end
end

# SEND OUTPUT TO CONSOLE

puts MyFirstPage.new
# => <!DOCTYPE html>\
#    <html lang='en'>\
#      <head profile='http://ab.c'>\
#        <meta charset='UTF-8'>\
#        <title>My First Page</title>\
#      </head>\
#      <body class='my-body-class'>\
#        <header id='header'>\
#          <h1 class='heading'>My First Heading Level</h1>\
#          <p class='description'>An awesome description</p>\
#        </header>\
#        <main id='main'>\
#          <p>Hello from Markout!</p>\
#        </main>\
#        <footer id='footer'>\
#          <!-- I'm unescaped -->\
#        </footer>\
#      </body>\
#    </html>

# OR, SERVE IT TO THE BROWSER

require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/html"
  context.response.print MyFirstPage.new
end

puts "Listening on http://#{server.bind_tcp(8080)}"

server.listen
# Visit 'http://localhost:8080' to see Markout in action
```

### Components

You may extract out shared elements that do not exactly fit into the page inheritance structure as components, and mount them in your pages:

```crystal
require "markout/html"

# Create your own base component
abstract struct BaseComponent
  include Markout::HTML::Component

  # Set HTML version
  #
  # Versions:
  #   `Version::HTML_5` (default)
  #   `Version::XHTML_1_1`
  #   `Version::XHTML_1_0`
  #   `Version::HTML_4_01`
  #private def version : Version
  #  Version::XHTML_1_1
  #end
end

# Create the component
struct MyFirstComponent < BaseComponent
  def initialize(users : Array(String)) : Nil
    render(users)
  end

  private def render(users : Array(String)) : Nil
    ul class: "users" do
      users.each do |user|
        li user, class: "user"
        # Same as `li class: "user" do text(user) end`
      end
    end
  end
end

# Mount the component
struct MySecondPage < BasePage
  def initialize(@users : Array(String)) : Nil
  end

  private def head_content : Nil
    title "Component Test"
  end

  private def body_content : Nil
    div class: "users-wrap" do
      mount MyFirstComponent, @users # Or `mount MyFirstComponent.new(@users)`
    end
  end
end

#puts MySecondPage.new(["Kofi", "Ama", "Nana"])
```

A component may accept named arguments:

```crystal
# Create the component
struct MyLinkComponent < BaseComponent
  def initialize(label : String, url : String, **opts) : Nil
    render(label, url, **opts)
  end

  private def render(label : String, url : String, **opts) : Nil
    args = opts.merge({href: url})
    args = {class: "link"}.merge(args)

    a label, **args
  end
end

# Mount the component
struct MyThirdPage < BasePage
  private def body_content : Nil
    div class: "link-wrap" do
      mount MyLinkComponent, "Abc", "http://ab.c", class: "x-link", "data-foo": "bar"
    end
  end
end

puts MyThirdPage.new
# => ...
#    <div class='link-wrap'>\
#      <a class='x-link' data-foo='bar' href='http://ab.c'>Abc</a>\
#    </div>
#    ...
```

### Custom Tags

You may define arbitrary tags with `#tag`. This is particularly useful for rendering JSX or similar:

```crystal
tag :MyApp, title: "My Awesome App" do
  p "My app is the best."
end
# => <MyApp title='My Awesome App'>\
#      <p>My app is the best.</p>\
#    </MyApp>

tag :MyApp, title: "My Awesome App"
# => <MyApp title='My Awesome App' />

tag :cuboid, width: 4, height: 3, length: 2 do
  text "A cuboid"
end
# => <cuboid width='4' height='3' length='2'>
#      A cuboid
#    </cuboid>
```

### Handy methods

Apart from calling regular HTML tags as methods, the following methods are available:

- `#text(text : String)`: Use this to render escaped text
- `#raw(text : String)`: Use this render unescaped text

## Integrations

### Amber Framework

When using **Markout** with [Amber framework](https://amberframework.org/), you should, additionally, `require "markout/amber"`:

```crystal
require "amber"
require "markout/html"
require "markout/amber"
```

**Markout** comes with `Markout::Amber::HTML` mixin, for including in your pages and components, and `Markout::Amber::Controller` for your controllers.

These make certain controller methods available in your pages. You may, thus, call these controller methods in your pages without an explicit receiver.

Define your components and pages as usual, with `@controller` as first parameter to the constructor.

```crystal
require "amber"
require "markout/html"
require "markout/amber"

# Define your base component
#
# Be sure to `include Markout::Amber::HTML`
abstract struct BaseComponent
  include Markout::HTML::Component
  include Markout::Amber::HTML

  # Set HTML version
  #
  # Versions:
  #   `Version::HTML_5` (default)
  #   `Version::XHTML_1_1`
  #   `Version::XHTML_1_0`
  #   `Version::HTML_4_01`
  #private def version : Version
  #  Version::XHTML_1_1
  #end
end

# Define components as usual
#
# Always pass `@controller` as first parameter
# to the constructor
struct MyAmberComponent < BaseComponent
  def initialize(@controller : Amber::Controller::Base)
    render
  end

  private def render
    small "My Amber Component"
  end
end

# Define your base page
#
# Be sure to `include Markout::Amber::HTML`
abstract struct BasePage
  include Markout::HTML::Page
  include Markout::Amber::HTML

  # Set HTML version
  #
  # Versions:
  #   `Version::HTML_5` (default)
  #   `Version::XHTML_1_1`
  #   `Version::XHTML_1_0`
  #   `Version::HTML_4_01`
  #private def version : Version
  #  Version::XHTML_1_1
  #end

  # ...
end

# Define pages as usual
#
# Always pass `@controller` as first parameter
# to the constructor
struct MyAmberPage < BasePage
  def initialize(@controller : Amber::Controller::Base, @title : String) : Nil
  end

  private def head_content : Nil
    title @title
  end

  private def body_content : Nil
    # controller methods can be called explicitly
    # Here, `#flash` is made available by the controller
    flash.each do |key, value|
      p value
    end

    p "This is a Amber page"

    mount MyAmberComponent
  end
end

# Define your base controller
#
# Be sure to `include Markout::Amber::Controller`
abstract class ApplicationController < Amber::Controller::Base
  include Markout::Amber::Controller
  # ...
end

# Render page in controller's action
class MyAmberController < ApplicationController
  def index
    flash[:hello] = "Hello amber"
    render MyAmberPage, "Amber page title"
    # Same as `render MyAmberPage.new(self, "Amber page title")`
  end
end
```

### Onyx Framework

When using **Markout** with [Onyx framework](https://onyxframework.org), you should, additionally, `require "markout/onyx"`:

```crystal
require "onyx/http"
require "markout/html"
require "markout/onyx"
```

**Markout** adds a `.html` macro to `Onyx::HTTP::View` that renders a html page for requests with `Accept` header of `text/html`.

```crystal
require "onyx/http"
require "markout/html"
require "markout/onyx"

class MyOnyxView
  include Onyx::HTTP::View

  html MyPage, title: "My Onyx View"
  # Same as `html MyPage.new(title: "My Onyx View")`
end
```

In `Onyx::HTTP::Endpoint`, **Markout** adds a `#view` method overload that accepts a view class name with arguments, instead of a view object.

```crystal
require "onyx/http"
require "markout/html"
require "markout/onyx"

class MyOnyxEndpoint
  include Onyx::HTTP::Endpoint

  def call
    view MyOnyxView, arg, arg2
    # Same as `view MyOnyxView.new(arg, arg2)`
  end
end
```

## Alternatives

Check out the following, if **Markout** does not fit your needs:

- [crystal-lang/html_builder](https://github.com/crystal-lang/html_builder)
- [Lucky framework](https://luckyframework.org/guides/rendering-html/) comes with an in-built html builder.

## Security

Kindly report suspected security vulnerabilities in private, via contact details outlined in this repository's `.security.txt` file.

## Contributing

1. [Fork it](https://github.com/grottopress/markout/fork)
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
