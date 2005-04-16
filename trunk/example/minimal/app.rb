#!/usr/bin/env ruby

$: << File.dirname(__FILE__) + '/../../lib'

require 'i18nservice'
require 'i18nconfig'


class Duck
  def talk
    puts _('I talk like a duck')
    puts _('Quack Quack !!')
  end
  def walk
    puts _('I walk like a duck')
  end
end

duck = Duck.new

duck.talk
duck.walk

puts "----------- I18nService.instance.lang = 'fr' ----------------------"
I18nService.instance.lang = 'fr'

duck.talk
duck.walk
