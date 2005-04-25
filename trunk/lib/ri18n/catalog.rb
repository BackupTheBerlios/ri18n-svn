class  Catalog < Hash
  

# TODO: fix order of header entries
  def po_header
    if self.has_key?("")
      h = self[""]
      ret = h[:comments].dup
      ret << PoSource::HEADER_SPLIT
      h[:ordered_entries].each{|key| ret << "\"#{key}: #{h[key]}\\n\"\n"}
      ret << "\n"
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

