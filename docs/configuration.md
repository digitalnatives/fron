# Configuration
Application configuration utility.

## Title
The layout of the application can be set with the 'title' DSL.

## Layout
The layout of the application can be set with the 'layout' DSL.

This DSL takes a block and runs it in the context of the main application component, with the injection poin for controllers as the argument.

## Routes
For using routes see the [routing documentation]().

## Example
```ruby
class TestApplication < Application
	config.title = 'Test Application'

	config.layout do |main|
		component :header, 'header'
		self << main
	end

	config.routes do
		map SiteController
	end
end
```
