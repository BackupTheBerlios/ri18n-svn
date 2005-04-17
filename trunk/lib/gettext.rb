require 'ri18n/standard_exts'

class I18nFileList < Rake::FileList
  MSG_PATTERN = /(?:n_|_|_i)\('(.+?)'\)/m

	def gettext 
    list = []
    each{|fn|
      next unless test(?f, fn)
      File.open(fn) do |f|
        list += f.read.scan(MSG_PATTERN).flatten
      end
    }
    list.uniq!
    ret = Hash.new
    list.each{|m| ret[m] = nil}
    ret
  end
end

