
require 'ri18n/standard_exts'
require 'rubygems'
require 'rake'

class GettextScanner < String
  MSG_PATTERN = /(?:n_|_|_i)\('(.+?)'\)/m
	
	def GettextScanner::Gettext(source)
		GettextScanner.new(source).gettext
	end
	
  def gettext
		self.scan(MSG_PATTERN).flatten.uniq
	end
end

class I18nFileList < Rake::FileList

	def gettext 
    list = []
    each{|fn|
      next unless test(?f, fn)
      File.open(fn) do |f|
        list += GettextScanner::Gettext(f.read)
      end
    }
    list.uniq!
    ret = Hash.new
    list.each{|m| ret[m] = nil}
    ret
  end
end

