class PoSource < String

  def parse
    ret = {}
    self.split(/(?:\n\n)|(?:\n \n)/m).each{|s|
      s =~ /msgid\s+(.+)msgstr\s+(.*)/m
      str = $2.strip
      id = $1.strip[1..-2]
      ret[id] = ((str == '""') ? nil : Msg.new(str[1..-2]) )
    }
    ret
  end
  
end
