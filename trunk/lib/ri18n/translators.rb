#!/usr/bin/env ruby

i18n = I18nService.instance

def _(string)
  I18nService.instance.table.fetch(string, string) || string
end

# string with interpolation part(s)
def _i(string, b = self.getBinding)
  ret = I18nService.instance.table.fetch(string, string) || string
  ret.interpolate(b)
end

# plurals
def n_(msgid, msgid_plural, n)
	if ret = I18nService.instance.table[msgid]
		ret.plurals[n==0 ? 0 : 1]
  else
		msgid_plural
	end
end

unless i18n.try_load
  i18n.table = {}
  def _(string)
    string
  end

  def _i(string, b = self.getBinding)
    string.interpolate(b)
  end

end