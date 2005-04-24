require 'test/unit'

require 'ri18n/langtools'

class LangToolsTest < Test::Unit::TestCase
  include LangTools
  def setup
    @lang = 'ja_JP.eucJP'
  end
  def teardown
    @lang = nil
  end
  def test_lang_code
    assert_equal('ja', language_code)
    assert_equal('ja', lc)
  end
  def test_country_code
    assert_equal('JP', country_code)
    assert_equal('JP', cc)
  end
  def test_encoding
    assert_equal('eucJP', lang_encoding)
    assert_equal('eucJP', le)
  end
end
