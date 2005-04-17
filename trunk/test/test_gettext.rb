#!/usr/bin/env ruby
require 'test/unit'
require 'gettext'

class GettextTest < Test::Unit::TestCase
  S1 = <<END_SOURCE
	blah blah
	<%= _('hello world')%> html stuff <%=_('bye bye')%>
	'dont catch me !'  << "'nor  me !!'"
	__('dont catch me !')
	(_('catch me')) [_('me too')]<%=_('only once') + _('only once')%>
END_SOURCE
	
  S2 = <<END_SOURCE
	blah blah
	<%= _("hello world")%> ("not me !!")
  <%= _('hello "world') 'not "me !!'%>
END_SOURCE

  S3 = <<END_SOURCE
  blah blah
  <%= _i("hello world")%> ("not me !!")
  <%= _i('hello "world') 'not "me !!'%>
END_SOURCE

  S4 = <<END_SOURCE
  blah blah
  <%= n_("%d file", "%d files", n)%> ("not me !!")
  <%= n_('%d time', '%d times', n) 'not "me !!'%>
END_SOURCE
	def test_simple
    assert_equal(["bye bye", "catch me", "hello world", 
                   "me too", "only once"], GettextScanner::Gettext(S1))
	end
	
	def test_dquotes
		assert_equal(['hello "world', 'hello world'], GettextScanner::Gettext(S2))
	end
  
  def test_interp
    assert_equal(['hello "world', 'hello world'], GettextScanner::Gettext(S3))
  end
  
  def test_plural
    assert_equal([['%d time', '%d times']], GettextScanner::Gettext(S4))
  end

end