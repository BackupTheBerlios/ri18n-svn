
require 'ri18n/standard_exts'
require 'rubygems'
require 'rake'

class GettextScanner < String
  SINGLE = "'(.+?)'"
  DOUBLE = '"(.+?)"'
  MSG_PATTERN_SINGLE = /\W_i?\(#{SINGLE}\)/mu
	MSG_PATTERN_DOUBLE = /\W_i?\(#{DOUBLE}\)/mu
  MSG_PATTERN_PLURAL = /\Wn_\(#{SINGLE},\s*#{SINGLE},\s*.+?\)/mu
	def GettextScanner::Gettext(source)
		GettextScanner.new(source).gettext
	end
	
  def gettext
		ret = (scan(MSG_PATTERN_SINGLE) + scan(MSG_PATTERN_DOUBLE)).flatten.uniq.sort
	  ret += scan(MSG_PATTERN_PLURAL).uniq.sort
    ret
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

