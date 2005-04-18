# class IdPlural < String
#   attr_reader :plural
#   def initialize(x, id_plural)
#     super(x)
#     @plural = id_plural
#   end
#   def plural
#     @plural
#   end
# end

class Msg < String
  attr_reader :comments, :reference, :flag
  attr_accessor :plurals, :id_plural
  ENTRY_REGEXP = /(#[.,:]?\s*.*?\n)?msgid\s+(.+?)msg(id_plural|str)\s+(.*)/m
  def Msg::Parse(entry)
      all, com, id, sel, str = *(ENTRY_REGEXP.match(entry))
      com = com ? com.split("\n") : []
      id.strip_q!
      if sel == 'str'
        str.strip_q!
        msg = ((str.empty?) ? nil : Msg.new(str, com ) )
        [id, msg]
      else 
        [id, Msg::Plurals(str, com)]
      end
  end
  
  MSGSTR_PLURAL_RE = /(.+?)(msgstr\[\d+\]\s+.+?)+/m
  def Msg::Plurals(entry, com)
    all, idp, pl = *(MSGSTR_PLURAL_RE.match(entry))
    plurals = pl.strip.split(/msgstr\[\d+\]/).collect!{|mp| mp.strip_q}.compact
    Msg.new(plurals[0], com, idp.strip_q, plurals)
  end
  
  def initialize(msg, comments, idp=nil, pl=nil)
    super(msg)
    @comments = comments
    parse_comments if @comments
    @id_plural = idp
    @plurals = pl
  end
  
  def parse_comments
    @reference = if r = @comments.find{|c| c =~ /\A#:/}
                    r[2..-1].strip
                 end 
    @flag = if r = @comments.find{|c| c =~ /\A#,/}
               r[2..-1].strip
            end
  end
end

