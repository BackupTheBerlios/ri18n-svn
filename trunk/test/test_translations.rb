#!/usr/bin/env ruby


require 'test_helper'


class PoPackagingTest < Test::Unit::TestCase
  def test_available
    wd = Dir.getwd
    assert_equal(%w{de fr}, I18N.available_languages)

    # check that workdir is not changed
    assert_equal(wd, Dir.getwd)
  end
end

class PluralTest < Test::Unit::TestCase

  def setup
		plural_setup
  end

	def teardown
		plural_teardown
	end

	def test_plural
		I18N.lang='plural'
		assert_equal 'fichiers', n_('file', 'files', 2)
	end

end

class TranslationIOTest < Test::Unit::TestCase

  def setup
    po = <<END_PO
msgid "hello"
msgstr "salut"

msgid "two"
msgstr "deux"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

END_PO

    I18N.in_po_dir do
      File.open('iotest', File::CREAT|File::WRONLY|File::TRUNC){|f|
                f << po
      }
    end
    interp_setup

  end

  def teardown
    I18N.in_po_dir do
      File.delete('iotest') if test(?f, 'iotest')
    end
    interp_teardown
  end

  def test_load
    assert_equal({'hello' => 'salut', 'two' => 'deux', 'blue' => 'bleu',
                  'untranslated' => nil }, I18N.read_po('iotest'))
  end

  def test_interp
    assert_equal({'#{@interpolation} test' => 'test #{@interpolation}',
                 'blue' => 'bleu'}, I18N.read_po('iotest_interp.po'))
  end


end

class TranslationTest < Test::Unit::TestCase
  # reset to default
  def setup
    interp_setup
    I18N.lang='xx'
    I18N.table = {'blue' => 'bleu', 'summer' => 'été', 'untranslated' => nil}
    I18N.write_po('xx')

    I18N.lang = nil
  end

  def teardown
    I18N.in_po_dir do
      File.delete(I18N.filename('xx')) if test(?f, I18N.filename('xx'))
    end
    interp_teardown
  end

  def test_interp_simple
    I18N.lang = 'iotest_interp'
    @interpolation = 'toto'
    assert_equal('test toto', _i('#{@interpolation} test') )

    @interpolation = 'tutu'
    assert_equal('test tutu', _i('#{@interpolation} test') )

  end


  def test_interp
    I18N.lang = 'iotest_interp'
    assert_equal({'#{@interpolation} test' => 'test #{@interpolation}',
                 'blue' => 'bleu'}, I18N.table)
    assert_equal('bleu', _('blue'))
    assert_equal('red', _('red'))

    @interpolation = _('blue')
    assert_equal('test bleu', _i('#{@interpolation} test') )

    @interpolation = _('red')
    assert_equal('test red', _i('#{@interpolation} test') )

  end


  def test_default_is_english
    assert_equal('Test String', _('Test String'))
  end

  def test_load_and_save
    assert_equal({}, I18N.table)
    assert_equal('blue', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('summer', _('summer'))

    I18N.lang = "xx"
    assert_equal({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => nil}, I18N.table)
    assert_equal('bleu', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('été', _('summer'))

  end

  def test_update
    I18N.update('xx', {'red' => nil, 'blue' => nil})
    assert_equal({'blue' => 'bleu', 'red' => nil,
                  'summer' => 'été', 'untranslated' => nil}, I18N.table)
  end

  def test_simple
    I18N.lang = "fr"
    assert_equal('Test de cuisson', _('Cooking test'))

    I18N.lang = "de"
    assert_equal('Kochtest', _('Cooking test'))
  end

  def test_utf8_chars
    I18N.lang = "fr"
    assert_equal('Chaîne de Test', _('Test String'))
    assert_equal('Été', _('Summer'))
    assert_equal('été', _('summer'))

    I18N.lang = "de"
    assert_equal('Straße', _('Road'))
  end
end