# Extend MyButton
class IconButton < MyButton
  extend Forwardable

  # Set the tag
  tag 'icon-button'

  # Add child components
  component :icon, :icon
  component :span, :span

  # Delegate methods
  def_delegators :span, :text=, :text

  # Style the icon, everything else is inherited
  style 'icon:before' => { fontFamily: 'FontAwesome',
                           display: 'inline-block',
                           marginRight: 10.px,
                           content: '"\f0f4"' }
end
