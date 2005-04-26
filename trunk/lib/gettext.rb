
require 'ri18n/standard_exts'
require 'ri18n/msg'
require 'ri18n/newmsglist'
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
	  plur = scan(MSG_PATTERN_PLURAL).uniq
    ret += plur.sort
    ret.collect{|m|
      case m
      when String # singular msg
        Msg.new(m.unescape_quote, nil)
      when Array # plural msg
        Msg.new(m[0].unescape_quote, nil, m[1].unescape_quote)
      end
    }
  end
end

# TODO: detect app KCODE (read config file ?) and write PO and POT files accordingly 

class I18nFileList < Rake::FileList

	def gettext 
    list = []
    each{|fn|
      next unless test(?f, fn)
      File.open(fn) do |f|
        list += GettextScanner::Gettext(f.read)
      end
    }
    NewMsgList.new(list.uniq)
  end
end

