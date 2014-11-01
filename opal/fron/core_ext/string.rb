# String
class String
  def camelize
    `#{self}.replace(/(?:-|_|(\/))([a-z\d]*)/gi,function(m,first,second){
      return second.charAt(0).toUpperCase() + second.substr(1).toLowerCase()
    })`
  end
end
