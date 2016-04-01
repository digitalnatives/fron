# Paragraph component with an image.
class ImageParagraph < Fron::Component
  tag 'image-paragraph'

  # Define components
  component :image,   :img
  component :content, :content

  # Set Styling
  style border: '1px solid #EEE',
        display: :block,
        padding: 20.px,
        img: { float: :left,
               marginRight: 20.px },
        '&:after' => { display: :block,
                       content: '""',
                       clear: :both }

  # Set data
  def initialize
    super
    @image[:src] = 'http://placehold.it/180/f9f9f9/666'
    @content.text = 'Lorem ipsum dolor sit amet, consectetur adipiscing
                     elit. Vivamus molestie placerat sem a ultrices.
                     Cras ultricies enim luctus enim aliquam convallis.
                     Sed et felis volutpat, suscipit urna et, malesuada
                     tellus. Nunc et tellus fringilla, tristique eros
                     et, aliquam nisi. Quisque faucibus porta odio non
                     mollis. Donec volutpat convallis blandit. Donec
                     non nisl elit. Quisque orci neque, consequat
                     interdum elit eu, auctor elementum magna.'
  end
end
