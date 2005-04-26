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
      ret = header_comments ? header_comments.dup.strip + "\n" : ''
      unless  header_entries.empty?
        ret << PoSource::HEADER_SPLIT
        header_entries.each{|key| ret << "\"#{key}: #{header[key]}\\n\"\n"}
        ret << "\n"
      end
    else
      ''
    end
  end

# TODO: test ordering of entries (also with plurals))
  def po_format(nplurals, app_enc='utf-8')
    ret = po_header
    sort.each{|id, str| 
      next if id == ""
      if str.respond_to? :po_format
        ret << str.po_format(id, nplurals)
      else
        ret << Msg.new(str.to_s, nil).po_format(id, nplurals)
      end
      }
    if encoding == app_enc.downcase
      ret
    else
      Iconv.new(encoding, app_enc).iconv(ret)
    end
  end 

end

