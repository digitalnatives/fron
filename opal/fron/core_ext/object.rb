# Object
# http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
class Object
  # Defines a class method
  #
  # @param name [String] The name of the method
  # @param blk [Block] The body of the method
  def metaDef(name, &blk)
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end
