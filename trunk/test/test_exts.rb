require 'test/unit'
require 'ri18n/standard_exts'

class StringInterpolateTest < Test::Unit::TestCase
  def test_unchanged
    string = 'blah'
    assert_equal string, string.interpolate(binding)
  end
  def test_simple
    @color = 'red'
    string = 'the horse is #{@color}'
    assert_equal 'the horse is red', string.interpolate(binding)
    
    @color = 'blue'
    assert_equal 'the horse is blue', string.interpolate(binding)
   
  end
end
