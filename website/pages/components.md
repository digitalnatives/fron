# 4. Components
Components are the main part of Fron. Everything is built around / for them, altough nothing in the library is using them so you can say that they are the end product.

## What is a component?
A **component** is basically a custom **HTML Element** that you can **add methods to**, **extend** and **compose** into other components. It is defined by `Fron::Component` class.

An input field using content-editable:

```ruby
# Extend from Fron::Component
class ContentEditable < Fron::Component
  # Set the tag
  tag 'content-editable'

  # When the element is blurred call the change method
  on :blur, :change

  # Initializes the compontent:
  # * Sets the contenteditable attribute to true
  # * Sets the spellcheck to false
  def initialize
    super
    self[:contenteditable] = true
    self.spellcheck = false
  end

  # Triggers the change event
  def change
    trigger 'change'
  end
end
```

## How does it work?
Basically the **native HTML Element** is **wrapped** in a Ruby class instance. If you are curious about the implementation check the [source](https://github.com/digitalnatives/fron/blob/master/opal/fron/core/component.rb).

## How it is different from Web Components?
[Web Components](https://css-tricks.com/modular-future-web-components/) use new technologies that are not available everywhere, also they introduce a lot of concepts that seem odd and complicated.

Fron components are straightforward and easy to learn.
