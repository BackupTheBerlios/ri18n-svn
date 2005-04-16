require 'test/unit'

require 'i18nservice'
I18N = I18nService.instance
I18N.po_dir = File.dirname(__FILE__) + '/po'

def interp_setup
    poi = <<'END_POI'

msgid "#{@interpolation} test"
msgstr "test #{@interpolation}"
 
msgid "blue"
msgstr "bleu"    

END_POI

    I18N.in_po_dir do
      File.open('iotest_interp.po',
                 File::CREAT|File::WRONLY|File::TRUNC){|f|  f << poi   }
    end
end

def interp_teardown
  I18N.in_po_dir do
    File.delete('iotest_interp.po') if test(?f, 'iotest_interp.po')
  end
end
