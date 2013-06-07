require 'pry'
class TestObject
  def m1
    "hello"
  end

  def m2
    "two"
  end

  def to_hash
    hash = {}
    methods = ["m1", "m2"]
    methods.each do |method|
      hash[method.to_sym] = self.send(method)
    end
    hash
  end
end


a = TestObject.new
puts a.to_hash
