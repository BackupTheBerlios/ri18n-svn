$: << File.dirname(__FILE__)

require 'singleton'
require 'fileutils'

require 'msglist'

class I18nService
  include Singleton
  attr_accessor :lang
  attr_accessor :table
  attr_accessor :po_dir
  MSG_PATTERN = /_i?\('(.+?)'\)/m
  FILE_SUFFIX = '.po'
  FILE_PATTERN = "*#{FILE_SUFFIX}"

  def lang=(l)
    unless ( @lang == l ) 
      @lang = l 
      load 'translators.rb' 
    end
  end

  def in_po_dir
    wd = Dir.getwd
    ret = nil
    begin
      Dir.chdir(@po_dir)
      ret = yield
    ensure
      Dir.chdir(wd)
    end
    ret
  end
  # access the po files
  def each_file
    in_po_dir do
      Dir[FILE_PATTERN].each{|fn| yield fn}
    end
  end
  
  def available_languages
    ret = in_po_dir do
      Dir[FILE_PATTERN]
    end
    ret.collect{|path| File.basename(path, FILE_SUFFIX)}.sort
  end  
  
  def update_languages(new_msgs)
    available_languages.each{|la| self.update(la, new_msgs)    }
  end
  
  def update(lang, new_msgs)
    self.lang = lang
    @table = new_msgs.update(@table)
    write_po(lang)
  end
  
  def filename(lang)
    lang + FILE_SUFFIX
  end
  
  def read_po(fn)
    ret = {}
    in_po_dir do
      File.read(fn).split(/(?:\n\n)|(?:\n \n)/m).each{|s|
        s =~ /msgid\s+(.+)msgstr\s+(.*)/m
        str = $2.strip
        id = $1.strip[1..-2]
        ret[id] = ((str == '""') ? nil : str[1..-2])
      }
    end
    ret
  end
  
  def try_load
    loaded = true	
    if @lang and @lang.kind_of?(String) then
      begin
        @table = read_po(filename(@lang))
      rescue Errno::ENOENT
        loaded = false
      end
    else
      loaded = false
    end
    loaded
  end
    
  def write_po(lang)
    fname = filename(lang)
    in_po_dir do
      FileUtils.cp(fname, "#{fname}.bak") if test(?f, fname)
      File.open(fname, File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << @table.po_format   
      }
    end
  end

end



