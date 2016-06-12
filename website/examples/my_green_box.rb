# Hulk SMASH!
class MyGreenBox < MyBox
  tag 'my-green-box'

  style justifyContent: :center,
        alignItems: :center,
        background: :green,
        display: :flex,
        span: { fontWeight: :bold,
                fontSize: 20.px,
                color: '#FFF' }

  component :span, :span, text: 'Doh!'
end
