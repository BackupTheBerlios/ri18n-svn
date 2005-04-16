class Msg < String
  attr_reader :comments, :reference, :flag
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

