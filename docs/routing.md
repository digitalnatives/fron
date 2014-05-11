# Routing
There are two leves of routing:

* Application level: This defines which controller is responsibe for specified paths
* Controller level: This defines which actions / sub controllers on the controller are called for specified paths

## Applications Routes
Routes are defined in the Application Configuration with the `routes` DSL method.

You can define controllers for specific paths, for example the following `map 'users/', UserController` will delegate all paths under the `users/` to the `UserController`. The controller only recieves the portion of the path which remains after the matched path.

## Controller Routes
Routes are defined with the `route` DSL method.

The first argument is the path, the second argument is the action / sub controller to be called. The path can contain parameter identifiers such as `:name`. These will be passed along to the action as a hash in the first parameter.

## Before Filters
Before filters can be added to the controllers actions with the `beforeFilter` DSL method.

The first argument is the action to be called, the second argument is an array of methods which before the action should be called.

## Example
```ruby
class TestApplication < Application
  config.routes do
    # Both 'users/new' and 'users/10' will be
    # handled by an instance of UserController
    map 'users/', UserController

    # Anything else will be handled by
    # an instance of IndexController
    map IndexController
  end
end

class CommentsController < Controller
  ...
end

class UserController < Controller
  # users/new -> UserController#authorize -> UserController#new
  route 'new', :new
  # users/10/comments -> CommentsController with params[:id] = 10
  route ':id/comments/', CommentsController
  # users/10  -> UserController#authorize -> USerController#user with params[:id] = 10
  route ':id', :user

  beforeFilter :authorize, [:new,:user]

  def new
    ...
  end

  def user(params)
    puts params[:id]
    ...
  end

  def authorize
    ...
  end
end
```
