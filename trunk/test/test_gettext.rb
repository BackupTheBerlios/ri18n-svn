#!/usr/bin/env ruby

require 'test/unit'
require 'gettext'

class GettextTest < Test::Unit::TestCase
  S1 = <<END_SOURCE
	blah blah
	<%= _('hello world')%> html stuff <%= _('bye bye')%>
END_SOURCE
	

	def test_simple
    assert_equal ['hello world', 'bye bye'], GettextScanner::Gettext(S1)
	end
end