
require 'test/unit'
require 'ri18n/msg'

class MsgTest < Test::Unit::TestCase
  
  def test_parse_comments
    m = Msg.new('message', ['#  translator-comments', 
                  '#. automatic-comments',
                  '#: reference...',
                  '#, flag...'])
    assert_equal 'reference...', m.reference
    assert_equal 'flag...', m.flag
  end
  
end
