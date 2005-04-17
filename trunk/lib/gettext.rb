
require 'ri18n/standard_exts'
require 'rubygems'
require 'rake'

class IdPlural < String
  attr_reader :plural
  def initialize(id, id_plural)
    super(id)
    @plural = id_plural
  end
end

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
	  plur = scan(MSG_PATTERN_PLURAL).uniq.collect!{|m|
      case m
      when String
        m
      when Array
        IdPlural.new(*m)
      end
    }
    ret + plur.sort
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

