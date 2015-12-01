# Extend from Fron::Component
class ContentEditable < Fron::Component
  # Set the tag
  tag 'content-editable'

  # When the element is blurred call the change method
  on :blur, :change

  # Set styles
  style background: '#F9F9F9',
        borderRadius: 5.px,
        display: :block,
        padding: 10.px

  # Initializes the compontent:
  # * Sets the contenteditable attribute to true
  # * Sets the spellcheck to false
  def initialize
    super
    self.contenteditable = true
    self.spellcheck = false
    self.text = 'Some default content...'
  end

  # Triggers the change event
  def change
    logger.info "The content is now: #{text}"
  end
end
