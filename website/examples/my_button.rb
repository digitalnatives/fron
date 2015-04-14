# Simple button class
class MyButton < Fron::Component
  # Set the tag
  tag 'my-button'

  # When click greet the user
  on :click, :greet

  # Some styling...
  style border: '1px solid #CCC',
        display: 'inline-block',
        background: '#F9F9F9',
        padding: '5px 15px',
        borderRadius: 5.px,
        cursor: :pointer

  # Set default text
  def initialize
    super
    self.text = 'Click Me!'
  end

  # Greet the user
  def greet
    alert('Hello there!')
  end
end
