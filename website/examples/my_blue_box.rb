# My sweet red box is gone....NOOOOOOOO!!!
class MyBlueBox < MyBox
  tag 'my-blue-box'

  # This is only needed if no style DSL is used
  ensure_styles!

  style background: :blue
end
