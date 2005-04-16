
require 'test/unit'
require 'ri18n/po'

class PoSourceTest < Test::Unit::TestCase
  def test_parse_one
    source = PoSource.new(<<PO_ONE
msgid "one"
msgstr "un"
PO_ONE
)
    assert_equal {'one' => 'un'}, source.parse
  end
end
