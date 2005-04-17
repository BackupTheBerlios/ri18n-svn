#!/usr/bin/env ruby
require 'test/unit'
require 'gettext'

class GettextTest < Test::Unit::TestCase
  S1 = <<END_SOURCE
	blah blah
	<%= _('hello world')%> html stuff <%= _('bye bye')%>
	'dont catch me !'
	__('dont catch me !')
	(_('catch me')) [_('me too')]
END_SOURCE
	

	def test_simple
    assert_equal ['hello world', 'bye bye', 'catch me', 'me too'], GettextScanner::Gettext(S1)
	end
end