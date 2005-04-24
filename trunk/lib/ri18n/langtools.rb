module LangTools
# the language code part from lang, eg 'ja' for @lang='ja_JP.eucJP'
  def language_code
    @lang[0,2]
  end
  alias_method :lc, :language_code
  
# the country code part from lang, eg 'JP' for @lang='ja_JP.eucJP'
  def country_code
    /\w\w_(\w\w)/.match(@lang)[1]
  end
  alias_method :cc, :country_code
 
# the charset encoding part from lang, eg 'eucJP' for @lang='ja_JP.eucJP'
  def lang_encoding
    /\w\w_\w\w\./.match(@lang).post_match
  end
  alias_method :le, :lang_encoding
 
end

