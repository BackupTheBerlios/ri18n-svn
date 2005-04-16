
class  Hash
  
  def po_format
    ret = ''
    each{|id, str| ret << "msgid \"#{id}\"\nmsgstr \"#{str}\"\n\n"}
    ret
  end

end

class Msg < String
  attr_reader :comments
  def initialize(msg, comments)
    super(msg)
    @comments = comments
  end
end

class String
  def interpolate(b)
    eval('"' + self + '"', b)
  end
end

class Object
  def getBinding
    binding
  end
end