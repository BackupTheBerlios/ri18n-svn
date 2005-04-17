case I18nService.instance.plural_family
	when :one
	def plural_form(n)
		0
	end
	when :two_germanic
	def plural_form(n)
		n == 1 ? 0 : 1
	end
	when :two_romanic
	def plural_form(n)
		n > 1 ? 1 : 0
	end
	
end
