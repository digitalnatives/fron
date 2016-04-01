require 'setup'

DOM::Document.body << Main.new
DOM::Window.trigger :popstate
