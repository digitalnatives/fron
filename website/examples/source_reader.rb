# Source Reader
class SourceReader < Fron::Component
  # Set the tag
  tag 'source-reader'

  # Button for initialize loading
  component :button, 'button Load source...'

  # Styles
  style whiteSpace: 'pre-wrap',
        background: '#F9F9F9',
        borderRadius: 5.px,
        display: :block,
        padding: 20.px

  # Event to load
  on :click, :button, :load

  # Load source
  def load
    request.get do |response|
      self.text = response.body.split("\n")[0..2].join("\n") + "\n..."
    end
  end

  private

  # Request object
  def request
    @request ||= Fron::Request.new '/assets/pages/utilities/request.md'
  end
end
