require 'test/unit'
require 'ri18n/catalog'

class CatalogTest < Test::Unit::TestCase
  def test_po_format
    c = Catalog.new
    c.replace({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""})
    expect = <<EOS
msgid "blue"
msgstr "bleu"

msgid "summer"
msgstr "été"

msgid "untranslated"
msgstr ""

EOS
    assert_equal expect, c.po_format(2)
  end

  def test_po_format_header
    c = Catalog.new
    header = {:comments => "# comment1\n# comment2", 
              :ordered_entries => ['Content-Type', 'Content-Transfer-Encoding'],
              'Content-Type' => 'text/plain; charset=utf-8',
              'Content-Transfer-Encoding' => '8bit',
              }
    c.replace({"" => header, 'blue' => 'bleu', 'untranslated' => ""})
    expect = <<'EOS'
# comment1
# comment2
msgid ""
msgstr ""
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

EOS
    assert_equal expect, c.po_format(2)
  end
  def test_po_format_comments
    c = Catalog.new
    mid = Msg.new('été', ['# comment1', '# comment2'])
    c.replace({'blue' => 'bleu', 'summer' => mid, 'untranslated' => ""})
    expect = <<EOS
msgid "blue"
msgstr "bleu"

# comment1
# comment2
msgid "summer"
msgstr "été"

msgid "untranslated"
msgstr ""

EOS
    assert_equal expect, c.po_format(2)
  end

  def test_po_format_plural
    c = Catalog.new
    midplural = Msg.new('toto', nil, '%i files', ['%i fichier', '%i fichiers'])
    c.replace({'blue' => 'bleu', '%i file' => midplural, 'untranslated' => ""})
    expect = <<EOS
msgid "%i file"
msgid_plural "%i files"
msgstr[0] "%i fichier"
msgstr[1] "%i fichiers"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

EOS
    assert_equal expect, c.po_format(2)
  end

end

