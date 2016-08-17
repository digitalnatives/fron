require 'setup'

# DOM::Document.body << Main.new
# DOM::Window.trigger :popstate

require 'fron/core/vcomponent'

module List
  extend Fron::VComponent

  def init
    { counter: 0 }
  end

  def request_data
    cmd :finished do
      p = Promise.new
      p.resolve 100
      p
    end
  end

  def update(msg, data, state)
    case msg
    when :request
      [ { counter: state[:counter] }, request_data ]
    when :increment
      [{ counter: state[:counter] + 1 }, nil]
    when :finished
      [{ counter: data }, nil]
    else
      [state]
    end
  end

  def render(data)
    puts data, self
    node :div do
      node :button, onclick: t(:increment) do
        text "Increment"
      end

      node :button, onclick: t(:request) do
        text "Request Data"
      end

      text "hello #{data[:counter]}"
    end
  end
end

class C < Fron::VDomRenderer
  tagname 'c'

  component List
end

DOM::Document.body << C.new
