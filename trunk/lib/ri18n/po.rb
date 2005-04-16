class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  def parse
    ret = {}
    self.split(ENTRY_SEP).each{|entry| 
      id, msg = Msg::Parse(entry)
      ret[id] = msg
    }
    ret
  end
  
end
