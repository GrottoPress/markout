struct MyVueComponent < BaseComponent
  private def render : Nil
    render_html
    render_js
  end

  private def render_html : Nil
    tag :template do
      div id: "app" do
        span "{{ message }}", "v-bind:foo.bar": "message"
        button "Click me!", "@click": "myClickHandler"
      end
    end
  end

  private def render_js : Nil
    script do
      raw <<-JS
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
      })
      JS
    end
  end
end
