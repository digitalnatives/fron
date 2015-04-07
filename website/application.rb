require 'fron'
require 'vendor/marked.min'

class Sidebar < Fron::Component
  class Item < Fron::Component
    tag 'header-item'
  end

  component :title,      'sidebar-title[target=home] Fron'
  component :about,      'sidebar-item[target=intro] Introduction'
  component :dom,        'sidebar-item[target=assumptions] Assumptions'
  component :components, 'sidebar-item[target=project-setup] Project Setup'
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
          counterIncrement: :items,
          padding: '10px 0',
          display: :block,
          '&:before' => {
            content: 'counter(items) ". "'
          },
          '+ sidebar-item' => {
            borderTop: '1px solid #DDD'
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
  component :container, 'container'

  stylesheet 'http://fonts.googleapis.com/css?family=Open+Sans:400,600,700'

  style fontFamily: 'Open Sans',
        height: '100vh',
        color: '#333',
        display: :flex,
        sidebar: {
          flex: '0 0 240px',
        },
        container: {
          overflow: :auto,
          padding: 20.px,
          flex: 1
        },
        h1: {
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
      @container.html = html
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
