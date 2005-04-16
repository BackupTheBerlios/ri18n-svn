require 'ri18n/msg'

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
