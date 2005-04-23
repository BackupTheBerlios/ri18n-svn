require 'ri18n/msg'

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
  
  def po_format(nplurals)
    ret = ''
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

class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  
  def initialize(*args)
    super
    @table = {}
    get_entries
  end
  
  def parse
    parse_header 
    @entries.each{|entry|
      next if entry.strip.empty?
      id, msg = Msg::Parse(entry)
      @table[id] = msg
    }
    @table
  end

  HEADER_SPLIT = "\n" + 'msgid ""' + "\n" + 'msgstr ""' + "\n"
	def parse_header
    return unless @entries.first.match(/\s+msgid ""\s+/m)
    source = @entries.shift
	  parsed_header = {}
    source.split(HEADER_SPLIT).last.scan(/"((?:\w|-)+?):([^"]+)"/){|k, v|
      parsed_header[k.strip] = v.strip
    }
    parsed_header
  end

  private
  def get_entries
    @entries = self.split(ENTRY_SEP)
  end
end
