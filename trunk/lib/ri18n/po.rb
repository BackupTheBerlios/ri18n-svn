require 'ri18n/msg'
require 'ri18n/pohelper'
require 'ri18n/newmsglist'
require 'iconv'

class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  include PoHelper
  
  attr_reader :table
  attr_reader :header
  def initialize(*args)
    super
    @table = Catalog.new
    set_entries
  end

# converts PO file entries to encoding *enc*
  def reencode(to_enc)
    return if encoding.downcase == to_enc.downcase
    @entries.collect!{|text| Iconv.new(to_enc, encoding).iconv(text)}
  end
    
  
  def parse(app_enc='utf-8')
    parse_header 
    reencode(app_enc)
    @entries.each{|entry|
      next if entry.strip.empty?
      id, msg = Msg::Parse(entry)
      @table[id] = msg
    }
    @table
  end
  
  HEADER_SPLIT = 'msgid ""' + "\n" + 'msgstr ""' + "\n"
	def parse_header
    return unless @entries.first.match(/\s+msgid ""\s+/m)
    source = @entries.shift
	  parsed_header = {}
    tmp = source.split(HEADER_SPLIT)
    parsed_header[:comments] = tmp.first
    parsed_header[:ordered_entries] = []
    tmp.last.scan(/"((?:\w|-)+?):([^"]+)\\n"/){|k, v|
      parsed_header[k.strip] = v.strip
      parsed_header[:ordered_entries] << k.strip
    }
# empty msgid is key for getting the parsed header
    @table[""] = parsed_header
    @header = parsed_header
  end

  private
  def set_entries
    @entries = self.split(ENTRY_SEP)
  end
end
