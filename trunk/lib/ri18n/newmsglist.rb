
class  NewMsgList < Array
  
  def pot_format(nplurals, app_enc)
    ret = <<EOS
msgid ""
msgstr ""
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=#{app_enc}\\n"
"Content-Transfer-Encoding: 8bit\\n"

EOS
    each{|x| 
      ret << x.pot_format(nplurals)
    }
    ret
  end

end
