require 'ri18n/msg'

class  Array
  
  def pot_format
    ret = ''
    each{|x| 
      ret << if x.respond_to?(:id_plural) and x.id_plural
         %Q(msgid "#{x}"\nmsgid_plural "#{x.id_plural}"\nmsgstr ""\n\n)
             else
         %Q(msgid "#{x}"\nmsgstr ""\n\n)
             end
}
    ret
  end

end
class  Hash
  
  def po_format
    ret = ''
    each{|x, str| 
      ret << if x.respond_to?(:id_plural) and x.id_plural
         %Q(msgid "#{x}"\nmsgid_plural "#{x.id_plural}"\nmsgstr "#{str}"\n\n)
             else
         %Q(msgid "#{x}"\nmsgstr "#{str}"\n\n)
             end
    }
    ret
  end

end

class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  def parse
    @table = {}
    self.split(ENTRY_SEP).each{|entry|
      id, msg = Msg::Parse(entry)
      @table[id] = msg
    }
		parse_header
    @table
  end

	def parse_header
		return unless @table.has_key?(nil)
		@table[nil]
	end
end
