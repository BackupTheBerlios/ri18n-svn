#!/usr/bin/env ruby
require 'test/unit'
require 'gettext'

class GettextTest < Test::Unit::TestCase
  S1 = <<-END_SOURCE
	blah blah
	<%= _('hello world')%> html stuff <%=_('bye bye')%>
	'dont catch me !'  << "'nor  me !!'"
	__('dont catch me !')
	(_('catch me')) [_('me too')]<%=_('only once') + _('only once')%>
  END_SOURCE
	
  S1N = S1 + <<-END_SOURCE
  blah blah
  <%= N_('N hello world')%> html stuff <%=N_('N bye bye')%>
  'dont catch me !'  << "'nor  me !!'"
  N__('dont catch me !')
  (N_('N catch me')) [N_('N me too')]<%=N_('N only once') + N_('N only once')%>
  END_SOURCE
  
  S1S = <<-END_SOURCE
  blah blah
  <%= s_('hello|world')%> html stuff <%=s_('bye|bye')%>
  'dont catch me !'  << "'nor  me !!'"
  s__('dont catch me !')
  (s_('|catch me')) [s_('x |me too')]<%=s_('a|only once') + s_('a|only once')%>
  <%=s_('b|only once') + s_('b|only once')%>
  END_SOURCE
  
  S2 = <<-END_SOURCE
	blah blah
	<%= _("hello world")%> ("not me !!")
  <%= _('hello "world') 'not "me !!'%>
  END_SOURCE

  S2B = S2 + <<-'END_SOURCE'
  a=<%= _('in category \'category\'')%>
  b=<%= _('in category (\'category\')')%>
  END_SOURCE
  
  S3 = <<-'END_SOURCE'
  blah blah
  <%= _i("hello world")%> ("not me !!")
  <%= _i('hello "world') 'not "me !!' ; %> 
  END_SOURCE

  S3B = S3 + <<-'END_SOURCE'
  a=<%= _i('in category \'#{@category}\'')%>
  b=<%= _i('in category (\'#{@category}\')')%>
  END_SOURCE

  S4 = <<-'END_SOURCE'
  blah blah _('singular')
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
  
  def test_quotes
    assert_equal([%q!in category ('category')!, %q!in category 'category'!],
                  GettextScanner::Gettext(S2B)[-2, 2])
    assert_equal([%q!in category ('#{@category}')!, %q(in category '#{@category}')],
                  GettextScanner::Gettext(S3B)[-2, 2])
  
  end
  
  def test_noop
    assert_equal(["N bye bye", "N catch me", "N hello world", 
                  "N me too", "N only once", 
                  "bye bye", "catch me", "hello world", 
                   "me too", "only once",
                  ], GettextScanner::Gettext(S1N))
  end
  
  def test_with_context
    assert_equal(["a|only once", "bye|bye", "b|only once",
                  "hello|world", "x |me too", "|catch me"], GettextScanner::Gettext(S1S))    
  end
  
  def test_plural
    g4 = GettextScanner::Gettext(S4)
    assert_equal(['singular', '%d time'], g4)
    assert_equal([nil, '%d times'], 
           g4.collect{|m| m.id_plural })
  end

end