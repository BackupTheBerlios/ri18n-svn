require 'ri18n/msg'
require 'iconv'

class  Array
  
  def pot_format(nplurals)
    ret = ''
    each{|x| 
      ret << x.pot_format(nplurals)
    }
    ret
  end

end

class  Hash
  
# TODO: fix order of header entries
  def po_header
    if self.has_key?("")
      h = self[""].dup
      ret = h[:comments].dup
      h.delete(:comments)
      ret << PoSource::HEADER_SPLIT
      h.each{|key, val| ret << "\"#{key}: #{val}\\n\"\n"}
      ret
    else
      ''
    end
  end

  def po_format(nplurals)
    ret = po_header
    each{|id, str| 
      if str.respond_to? :po_format
        ret << str.po_format(id, nplurals)
      else
        ret << Msg.new(str.to_s, nil).po_format(id, nplurals)
      end
    }
    ret
  end 

end

module PoHelper
  def parse_content_type(ctype)
    %r{((?:\w|\d|[-/])+);\s+charset=((?:\w|\d|-)+)\z}.match(ctype).to_a[1,2]
  end
end

class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  include PoHelper
  
  def initialize(*args)
    super
    @table = {}
    set_entries
  end

# converts PO file entries to utf-8 
  def convert_to_utf8
# return if there is was no PO headerto get a charset from
    return unless h = @table[""]
    type, charset = parse_content_type(h['Content-Type'])
    @entries.collect!{|text| Iconv.new('utf-8', charset).iconv(text)}
  end
    
  
  def parse
    parse_header 
    convert_to_utf8 
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
    tmp.last.scan(/"((?:\w|-)+?):([^"]+)\\n"/){|k, v|
      parsed_header[k.strip] = v.strip
    }
# empty msgid is key for getting the parsed header
    @table[""] = parsed_header
    parsed_header
  end

  private
  def set_entries
    @entries = self.split(ENTRY_SEP)
  end
end
