
class  NewMsgList < Array
  
  def pot_format(nplurals)
    ret = ''
    each{|x| 
      ret << x.pot_format(nplurals)
    }
    ret
  end

end
