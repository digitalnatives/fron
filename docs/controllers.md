# Controllers
Controllers are responsible for parts of the application, it handles state / view changes for itself only.

## Base Component
The base component can be specified with the `base` DSL method.

The base component is the "page" wthich is injected into the document when a route matches this controller. It is accessible with the `@base` attribute. It must be a subclass of `Component`.

## Global Events
A controller can listen on Global Events with the `on` DSL.

The first argument is the event to listen to and the second argument is the method to run when the event triggered. Globa Events can be trigger like so:
```ruby
Eventable.trigger 'load'
```

## Routes
For using routes see the [routing documentation]().

## Example
```ruby
class TestController < Controller
  base BaseComponent

  on :load, :loaded

  def loaded

  end

  def test
    puts @base
  end
end
```
