require 'ri18n/pohelper'

class  Catalog < Hash
  
  include PoHelper
  
# in PO, header is defined as empty msgstr
  def header
    self[""]
  end
  
# ordered header entries (keys) 
  def header_entries
    header[:ordered_entries]
  end
  
  def header_comments
    header[:comments]
  end

    
  def po_header
    if header
      ret = header_comments.dup
      ret << PoSource::HEADER_SPLIT
      header_entries.each{|key| ret << "\"#{key}: #{header[key]}\\n\"\n"}
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

