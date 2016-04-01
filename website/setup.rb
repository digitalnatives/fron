require 'fron'
require 'vendor/highlight'
require 'vendor/highlight.ruby'
require 'vendor/marked.min'

require 'examples/content_editable'
require 'examples/my_button'
require 'examples/converter'
require 'examples/icon_button'
require 'examples/source_reader'
require 'examples/image_paragraph'
require 'examples/text_area'

%x{
  marked.setOptions({
    highlight: function(code) {
      return hljs.highlightAuto(code).value;
    }
  });
}

class Sidebar < Fron::Component
  class Item < Fron::Component
    tag 'header-item'
  end

  component :title,      'sidebar-title[target=home] Fron'
  component :about,      'sidebar-item[target=intro] Introduction'
  component :dom,        'sidebar-item[target=getting-started] Getting Started'
  component :setup,      'sidebar-item[target=the-dom] The DOM'
  component :components, 'sidebar-item[target=components] Components'
  component :components, 'sidebar-sub-item[target=components/inheritance] Inheritance'
  component :components, 'sidebar-sub-item[target=components/composition] Composition'
  component :components, 'sidebar-sub-item[target=components/events] Events'
  component :components, 'sidebar-sub-item[target=components/routes] Routes'
  component :components, 'sidebar-sub-item[target=components/styles] Styles'
  component :behaviors,  'sidebar-item[target=utilities] Utilities'
  component :behaviors,  'sidebar-sub-item[target=utilities/request] Request'
  component :behaviors,  'sidebar-sub-item[target=utilities/local-storage] Local Storage'

  style counterReset: :items,
        padding: 20.px,
        'sidebar-title' => {
          borderBottom: '2px solid #EEE',
          paddingBottom: 5.px,
          marginBottom: 10.px,
          display: :block,
          fontWeight: 600,
          fontSize: 24.px
        },
        '[target]' => {
          cursor: :pointer
        },
        'sidebar-item' => {
          borderBottom: '1px solid #EEE',
          counterIncrement: :items,
          counterReset: :subitems,
          padding: '10px 0',
          display: :block,
          '&:before' => {
            content: 'counter(items) ". "'
          }
        },
        'sidebar-sub-item' => {
          borderBottom: '1px solid #EEE',
          counterIncrement: :subitems,
          padding: '10px 0',
          paddingLeft: 10.px,
          display: :block,
          '&:before' => {
            content: 'counter(items) "." counter(subitems) ". "'
          }
        }

  on :click, '[target]', :navigate

  def navigate(event)
    DOM::Window.state = "/#{event.target[:target]}"
  end
end

class Main < Fron::Component
  include Fron::Behaviors::Routes

  component :sidebar, Sidebar
  component :wrapper, :wrapper do
    component :container, :container
  end

  stylesheet '//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  stylesheet '//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/tomorrow.min.css'

  style fontFamily: 'Open Sans',
        width: 1200.px,
        margin: '0 auto',
        color: '#444',
        a: {
          textDecoration: :none,
          color: '#00ACE6'
        },
        sidebar: {
          width: 240.px,
          float: :left
        },
        pre: {
          background: '#F9F9F9',
          borderRadius: 5.px,
          padding: 20.px
        },
        wrapper: {
          overflow: :auto,
          padding: 40.px,
          paddingBottom: 60.px,
          marginLeft: 240.px,
          display: :block
        },
        h1: {
          lineHeight: '1em',
          marginTop: 0
        }

  route '(.*)', :page

  def initialize
    super
    @pages = {}
    Fron::Sheet.render_style_tag
    Fron::Behaviors::Routes.listen
  end

  def home
    DOM::Window.state = '/home'
  end

  def page(page)
    return home if page == '/'
    load page do |html|
      @wrapper.container.html = html
      @wrapper.container.find_all('example').each do |example|
        example << Module.const_get(example['class']).new
      end
    end
  end

  def load(page)
    return yield @pages[page] if @pages[page]
    Fron::Request.new("/assets/pages#{page}.md").get do |response|
      @pages[page] = `marked(#{response.body})`
      yield @pages[page]
    end
  end
end

Fron::Behaviors::Style::Sheet.add_rule '*', { boxSizing: 'border-box' }, '0'
Fron::Behaviors::Style::Sheet.add_rule 'body', { margin: 0,
                                                 overflowY: :scroll,
                                                 fontSize: 18.px,
                                                 lineHeight: 26.px }, '1'
