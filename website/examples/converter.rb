# Celsius to Fahrenheit Converter
class Converter < Fron::Component
  # Celsius part
  component :celcius, :div do
    component :label, 'label Celsius: '
    component :input, 'input[value=0]'
  end

  # Fahrenheit part
  component :fahrenheit, :div do
    component :label, 'label Fahrenheit:'
    component :result, 'span 32'
  end

  # Button
  component :button, 'button Convert'

  # We will convert on click of the button
  on :click, 'button', :convert
  # or on change of the input
  on :change, :convert

  # Styling
  style background: '#F9F9F9',
        display: :block,
        padding: 10.px,
        label: { display: :block },
        div: { display: 'inline-block',
               marginRight: 5.px },
        button: { position: :relative,
                  height: 30.px,
                  top: -1.px },
        'input, span' => {
          display: 'inline-block',
          border: '1px solid #ddd',
          padding: '5px',
          lineHeight: 20.px,
          fontSize: 14.px,
          height: 20.px,
          width: 200.px
        }

  # Converting Logic
  def convert
    @fahrenheit.result.text = @celcius.input.value.to_i * 9 / 5 + 32
  end
end
