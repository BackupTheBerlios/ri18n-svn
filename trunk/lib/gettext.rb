require 'i18nservice'
require 'ri18n/standard_exts'

I18N = I18nService.instance


class I18nFileList < Rake::FileList
  def msg_list 
    list = []
    each{|fn|
      next unless test(?f, fn)
      File.open(fn) do |f|
        list += f.read.scan(I18nService::MSG_PATTERN).flatten
      end
    }
    list.uniq!
    ret = Hash.new
    list.each{|m| ret[m] = nil}
    ret
  end
  def update
	  I18N.write_pot(msg_list)
		I18N.update_catalogs(msg_list)
  end
end

