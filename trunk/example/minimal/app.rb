#!/usr/bin/env ruby

$: << File.dirname(__FILE__) + '/../../lib'

require 'i18nservice'
require 'i18nconfig'

puts _('hey')

puts _('loading french')

I18nService.instance.lang = 'fr'

puts _('hey')

puts _('bye')