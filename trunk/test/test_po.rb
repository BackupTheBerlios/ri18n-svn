
require 'test/unit'
require 'ri18n/po'

class PoSourceTest < Test::Unit::TestCase
  
  P1 = <<PO_END
msgid "one"
msgstr "un"
PO_END

  P2 = P1 + <<PO_END
 
msgid "two"
msgstr "deux"
PO_END

  P3 = <<PO_END + P1
# a comment
PO_END

  def test_parse_one
    assert_equal({'one' => 'un'}, PoSource.new(P1).parse )
  end
  
  def test_parse_two
    assert_equal({'one' => 'un', 'two' => 'deux'}, PoSource.new(P2).parse )
  end
  
  def test_parse_with_comment
    p3 = PoSource.new(P3).parse
    assert_equal({'one' => 'un'}, p3)
    
    assert_respond_to(p3['one'], :comments)
    assert_equal(['a comment'], p3['one'].comments)
    
  end
  
end
