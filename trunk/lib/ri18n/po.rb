class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  ENTRY_REGEXP = /(?:#\s*(.*?)\n)?msgid\s+(.+)msgstr\s+(.*)/m
  def parse
    ret = {}
    self.split(ENTRY_SEP).each{|s|
      s =~ ENTRY_REGEXP
      str = $3.strip
      id = $2.strip[1..-2]
      com = $1 ? $1.split("\n") : [] 
      ret[id] = ((str == '""') ? nil : Msg.new(str[1..-2], com ) )
    }
    ret
  end
  
end
