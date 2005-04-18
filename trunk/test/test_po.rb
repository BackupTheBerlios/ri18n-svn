
require 'test/unit'
require 'ri18n/po'

class PoFormatTest < Test::Unit::TestCase
  def test_po_format
    x = Msg.new('%d time', nil, '%d times')
    msg_list = {'singular' => nil, x => nil}
    plurals = {x => '%d times'}
    expected = <<END_PO
msgid "singular"
msgstr ""

msgid "%d time"
msgid_plural "%d times"
msgstr ""

END_PO
    assert_equal expected, msg_list.po_format(plurals)
  end
end

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
#  translator-comments
#. automatic-comments
#: reference...
#, flag...
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
    assert_equal(['#  translator-comments', 
                  '#. automatic-comments',
                  '#: reference...',
                  '#, flag...'], p3['one'].comments)
    
  end
  
end
