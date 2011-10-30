class Customer

	attr_accessor

	def initialize

	end

	def add (name, address, phone)
		begin
			validation = Validation.new
			validation.checkValidName(name)
			validation.checkValidAddress(address)
			validation.checkValidPhone(phone)
			custID = ($db.execute("select max(cust_id) from customers"))[0]['max(cust_id)']
			custID = (custID == nil ? 0 : custID + 1)
			$db.execute("insert into customers values(#{custID}, '#{name.upcase}', '#{address.upcase}', '#{phone}', 'Y', '', '#{CURRENT_DATE}', '#{CURRENT_DATE}')");
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def remove(custID)
		begin
			Validation.new.checkValidInt(custID)
			$db.execute("update customers set cust_active = 'N' where cust_id = #{custID}")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def modify (field, newValue, custID)
		begin
			validation = Validation.new
			validation.checkValidInt(custID)
			case field
				when "cust_name"
					validation.checkValidName(newValue)
				when "cust_address"
					validation.checkValidAddress(newValue)
				when "cust_phone"
					validation.checkValidPhone(newValue)
				else
					raise RuntimeError, ERR_INVALID_ACTION, ERR_LOC_CUST_MOD
			end
			$db.execute("update customers set #{field} = '#{newValue}', last_updated_dt = '#{CURRENT_DATE}' where cust_id = #{custID}");
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def searchByName (name)
		begin
			return $db.execute("select * from customers where cust_active = 'Y' and cust_name like '%#{name.upcase}%'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listAll
		begin
			return $db.execute("select * from customers where cust_active = 'Y'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def retrieve (custID)
		begin
			Validation.new.checkValidInt(custID)
			return $db.execute("select * from customers where cust_id = #{custID}")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
	
	def isNotDuplicate (name)
		begin
			Validation.new.checkValidName(name)
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
end


