require 'fron'
require 'vendor/highlight'
require 'vendor/highlight.ruby'
require 'vendor/marked.min'

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
  component :dom,        'sidebar-item[target=assumptions] Assumptions'
  component :setup,      'sidebar-item[target=project-setup] Project Setup'
  component :components, 'sidebar-item[target=components] Components'
  component :components, 'sidebar-sub-item[target=events] Events'
  component :components, 'sidebar-sub-item[target=composition] Composition'
  component :components, 'sidebar-sub-item[target=inheritance] Inheritance'
  component :behaviors,  'sidebar-item[target=behaviors] Behaviors'

  style background: '#EEE',
        counterReset: :items,
        padding: 20.px,
        'sidebar-title' => {
          borderBottom: '2px solid #DDD',
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
          borderBottom: '1px solid #DDD',
          counterIncrement: :items,
          counterReset: :subitems,
          padding: '10px 0',
          display: :block,
          '&:before' => {
            content: 'counter(items) ". "'
          }
        },
        'sidebar-sub-item' => {
          borderBottom: '1px solid #DDD',
          counterIncrement: :subitems,
          padding: '10px 0',
          paddingLeft: 10.px,
          display: :block,
          '&:before' => {
            content: 'counter(items) ". " counter(subitems) ". "'
          }
        }

  on :click, '[target]', :navigate

  def navigate(event)
    DOM::Window.state = event.target[:target]
  end
end

class Main < Fron::Component
  include Fron::Behaviors::Routes

  component :sidebar, Sidebar
  component :wrapper, :wrapper do
    component :container, :container
  end

  stylesheet 'http://fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  stylesheet 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/tomorrow.min.css'

  style fontFamily: 'Open Sans',
        height: '100vh',
        color: '#444',
        display: :flex,
        a: {
          textDecoration: :none,
          color: '#00ACE6'
        },
        sidebar: {
          flex: '0 0 240px'
        },
        pre: {
          background: '#F9F9F9',
          padding: 20.px
        },
        wrapper: {
          overflow: :auto,
          padding: 40.px,
          paddingBottom: 60.px,
          flex: 1,
          container: {
            display: :block,
            maxWidth: 900.px,
            margin: '0 auto'
          }
        },
        h1: {
          lineHeight: '1em',
          marginTop: 0
        }

  route '(.*)', :page

  def initialize
    super
    @pages = {}
  end

  def home
    DOM::Window.state = '/home'
  end

  def page(page)
    return home if page == '/'
    load page do |html|
      @wrapper.container.html = html
    end
  end

  def load(page)
    return yield @pages[page] if @pages[page]
    Fron::Request.new("assets/pages#{page}.md").get do |response|
      @pages[page] = `marked(#{response.body})`
      yield @pages[page]
    end
  end
end

DOM::Document.body.style.margin = 0
DOM::Document.body.style.fontSize = 18.px
DOM::Document.body << Main.new

DOM::Window.trigger :popstate
