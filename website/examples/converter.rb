# Celsius to Fahrenheit Converter
class Converter < Fron::Component
  # Celsius part
  component :celcius, :div do
    component :label, 'label', text: 'Celsius: '
    component :input, 'input', value: 0
  end

  # Fahrenheit part
  component :fahrenheit, :div do
    component :label, 'label', text: 'Fahrenheit:'
    component :result, 'span', text: '32'
  end

  # Button
  component :button, 'button', text: 'Convert'

  # We will convert on click of the button
  on :click, 'button', :convert
  # or on change of the input
  on :change, :convert

  # Styling
  style background: '#F9F9F9',
        alignItems: 'flex-end',
        display: :flex,
        padding: 10.px,
        label: { display: :block },
        div: { flexDirection: :column,
               marginRight: 5.px,
               display: :flex },
        button: { position: :relative,
                  height: 30.px,
                  top: -1.px },
        'input, span' => {
          display: 'inline-block',
          border: '1px solid #ddd',
          lineHeight: 20.px,
          fontSize: 14.px,
          padding: 5.px,
          height: 30.px,
          width: 200.px
        }

  # Converting Logic
  def convert
    @fahrenheit.result.text = @celcius.input.value.to_i * 9 / 5 + 32
  end
end
