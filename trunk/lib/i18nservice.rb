$: << File.dirname(__FILE__)

require 'singleton'
require 'fileutils'

require 'ri18n/standard_exts'
require 'ri18n/po'

class I18nService
  include Singleton
  attr_accessor :lang
  attr_accessor :table
  attr_accessor :po_dir
  
  FILE_SUFFIX = '.po'
  FILE_PATTERN = "*#{FILE_SUFFIX}"
	PLURAL_FAMILIES = {
	:one => %w(hu ja ko tr),
	:two_germanic => %w(da nl en de no sv et fi el he it pt es eo),
	:two_romanic => %w(fr pt_BR),
	:three_celtic => %w(ga gd),
	:three_baltic_latvian => %w(lv),
	:three_baltic_lithuanian => %w(lt),
	:three_slavic_russian => %w(hr cs ru sk uk),
	:three_slavic_polish => %w(pl),
	:four => %w(sl)}
  def lang=(l)
    unless ( @lang == l ) 
      @lang = l 
			load 'ri18n/plural_forms.rb'
      load 'ri18n/translators.rb' 
    end
  end

	def plural_family
		if @lang
			if found = PLURAL_FAMILIES.find{|fam, list| list.include?(@lang)}
				found.first
			else
				:two_germanic
			end
		else
			:two_germanic	
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
  
  def update_catalogs(new_msgs)
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
    in_po_dir do
      PoSource.new(File.read(fn)).parse
    end
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
  
  # write a formated file with the english strings to translate
  def write_pot(t)
    fname = 'en.pot'
    in_po_dir do
      FileUtils.cp(fname, "#{fname}.bak") if test(?f, fname)
      File.open(fname, File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << t.po_format   
      }
    end
  end

end


# this is needed so that translators and plural forms get loaded
# even if the app that uses i18nservice does not set a language
load 'ri18n/plural_forms.rb'
load 'ri18n/translators.rb' 

