require 'ri18n/msg'

class  Hash
  
  def po_format
    ret = ''
    each{|id, str| ret << "msgid \"#{id}\"\nmsgstr \"#{str}\"\n\n"}
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
