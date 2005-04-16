require 'pp'

class Msg < String
  ENTRY_REGEXP = /(#[.,:]?\s*.*?\n)?msgid\s+(.+?)msg(id_plural|str)\s+(.*)/m
  attr_reader :comments, :reference, :flag
  attr_accessor :plurals, :id_plural
  def Msg::Parse(entry)
      entry =~ ENTRY_REGEXP
      com, id, sel, str = [$1, $2, $3, $4]
      com = com ? com.split("\n") : []
      
      if id.nil?
        pp [com, id, sel, str]
        pp entry 
        exit
      end 
      id = id.strip[1..-2]
      if sel == 'str'
        str = str.strip
        msg = ((str == '""') ? nil : Msg.new(str[1..-2], com ) )
        [id, msg]
      else 
        [id, Msg::Plurals(str, com)]
      end
  end
  
  MSGSTR_PLURAL_RE = /(.+?)(msgstr\[\d+\]\s+.+?)+/m
  def Msg::Plurals(entry, com)
    entry =~ MSGSTR_PLURAL_RE
    idp, pl = [$1, $2]
    plurals = pl.strip.split(/msgstr\[\d+\]/).collect!{|mp| mp.strip[1..-2]}.compact
    m = Msg.new(plurals[0], com)
    m.plurals = plurals
    m.id_plural = idp.strip[1..-2]
    m
  end
  
  def initialize(msg, comments)
    super(msg)
    @comments = comments
    parse_comments
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

