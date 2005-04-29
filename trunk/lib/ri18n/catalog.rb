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

    
  def po_header(nplurals, app_enc)
    if header
      ret = header_comments ? header_comments.dup.strip + "\n" : ''
      unless  header_entries.empty?
        ret << PoSource::HEADER_SPLIT
        header_entries.each{|key| ret << "\"#{key}: #{header[key]}\\n\"\n"}
        ret << "\n"
      end
    else
      <<-EOS
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR Free Software Foundation, Inc.
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n"
"POT-Creation-Date: 2002-12-10 22:11+0100\\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n"
"Language-Team: LANGUAGE <LL@li.org>\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=#{app_enc}\\n"
"Content-Transfer-Encoding: 8bit\\n"
"Plural-Forms: nplurals=#{nplurals}; plural=n == 0;\\n"

      EOS
    end
  end

# TODO: test ordering of entries (also with plurals))
  def po_format(nplurals, app_enc='utf-8')
    ret = po_header(nplurals, app_enc)
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

