# Text Area component
class TextArea < Fron::Component
  # Set the tag
  tag 'text-area'

  # Create textarea
  component :textarea, :textarea

  # Save on input
  on :input, :save

  # Styles
  style textarea: { border: '1px solid #EEE',
                    fontFamily: 'Open Sans',
                    minHeight: 100.px,
                    fontSize: 18.px,
                    padding: 20.px,
                    width: '100%' }

  # Load on initialization
  def initialize
    super
    load
  end

  # Load from LocalStorage
  def load
    @textarea.value = storage.get(:value).to_s
  end

  # Save to LocalStorage
  def save
    storage.set :value, @textarea.value
  end

  private

  # Helper method
  def storage
    Fron::Storage::LocalStorage
  end
end
