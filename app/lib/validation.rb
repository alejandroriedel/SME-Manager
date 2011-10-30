class Validation

	def initialize

	end

	def checkValidName (name)
		(raise RuntimeError, "#{ERR_INVALID_NAME} '#{name}'", ERR_LOC_VAL_NAME) if name.length < 3 || (name.gsub(/[- ]/,'') =~ /\W/) != nil
	end

	def checkValidAddress (address)
		if address.length < 3 || address.scan(/\w+/).length < 2 || address.scan(/\d+/).length < 1 || (address.gsub(/[- ]/,'') =~ /\W/) != nil
			raise RuntimeError, "#{ERR_INVALID_ADDRESS} '#{address}'", ERR_LOC_VAL_ADDRESS
		end
	end

	def checkValidPhone (phone)
		flagValidPhone = true
		if phone.gsub('-','').scan(/\D/).length == 0
			if phone.length == 9
				phone.scan(/\d+/).each { |x| flagValidPhone = false if x.length != 4 }
			elsif phone.length == 12
				auxPhone = phone.scan(/\d+/)
				flagValidPhone = false if auxPhone[0].length != 2 || auxPhone[1].length != 4 || auxPhone[2].length != 4
			else
				flagValidPhone = false
			end
		else
			flagValidPhone = false
		end
		raise RuntimeError, "#{ERR_INVALID_PHONE} '#{phone}'", ERR_LOC_VAL_PHONE if !flagValidPhone
	end

	def checkValidFloat (floatNum)
		raise RuntimeError, "#{ERR_INVALID_FLOAT} '#{floatNum}'", ERR_LOC_VAL_FLOAT if floatNum.class != Float || floatNum.to_s.sub('.','').scan(/\D/).length != 0
	end

	def checkValidInt (intNum)
		raise RuntimeError, "#{ERR_INVALID_INT} '#{intNum}'", ERR_LOC_VAL_INT if intNum.class != Fixnum || intNum.to_s.scan(/\D/).length != 0
	end

	def checkValidDate (date)
		months30days = ["04","06","09","11"]
		if date.gsub('-','').scan(/\D/).length == 0
			if date.length == 10
				auxDate = date.scan(/\d+/)
				leapYear = (((auxDate[0].to_f / 4) - (auxDate[0].to_i / 4)) > 0 ? false : true)
				if auxDate[0].length != 4 || auxDate[1].length != 2 || auxDate[2].length != 2
					raise RuntimeError, "#{ERR_INVALID_DATE_FMT} '#{date}'", ERR_LOC_VAL_DATE
				elsif auxDate[1].to_i > 12 || auxDate[1].to_i < 1
					raise RuntimeError, "#{ERR_INVALID_MONTH} '#{date}'", ERR_LOC_VAL_DATE
				elsif auxDate[2].to_i > 31 || auxDate[2].to_i < 1 || (months30days.include?(auxDate[1]) && auxDate[2].to_i > 30) || 
					(leapYear && auxDate[1].to_i == 2 && auxDate[2].to_i > 29) || (!leapYear && auxDate[1].to_i == 2 && auxDate[2].to_i > 28)
					raise RuntimeError, "#{ERR_INVALID_DATE} '#{date}'", ERR_LOC_VAL_DATE
				elsif date < CURRENT_DATE
					raise RuntimeError, "#{ERR_INVALID_PAST_DATE} '#{date}'", ERR_LOC_VAL_DATE
				end
			else
				raise RuntimeError, "#{ERR_INVALID_DATE_LEN} '#{date}'", ERR_LOC_VAL_DATE
			end
		else
			raise RuntimeError, "#{ERR_INVALID_DATE_CHAR} '#{date}'", ERR_LOC_VAL_DATE
		end
	end

	def checkValidProducts (products)

	end

	def checkValidPrice (price)
		checkValidFloat(price)
		raise RuntimeError, "#{ERR_INVALID_PRICE} #{price}", ERR_LOC_VAL_PRICE if price <= 0
	end

	def guiCheckValidInt(intStr)
		raise RuntimeError, "#{ERR_INVALID_INT} '#{intStr}'", ERR_LOC_VAL_GUI_INT if intStr == "" || intStr.scan(/\D/).length > 0
	end

	def guiCheckValidFloat(floatStr)
		raise RuntimeError, "#{ERR_INVALID_INT} '#{floatStr}'", ERR_LOC_VAL_GUI_FLOAT if floatStr == "" || floatStr.sub('.','').scan(/\D/).length > 0
	end

	def guiCheckValidString(str)
		raise RuntimeError, "#{ERR_INVALID_STR} '#{str}'", ERR_LOC_VAL_GUI_STR if str == "" || str.gsub(/[- ]/,'').scan(/\W/).length > 0
	end
end
