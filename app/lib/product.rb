class Product

	attr_accessor

	def initialize

	end

	def add (name, price, stock)
		begin
			name = name.upcase
			validation = Validation.new
			validation.checkValidName(name)
			validation.checkValidPrice(price)
			validation.checkValidInt(stock)
			prodID = ($db.execute("select max(prod_id) from products"))[0]['max(prod_id)']
			prodID = (prodID == nil ? 0 : prodID + 1)
			$db.execute("insert into products values(#{prodID}, '#{name}', #{price}, #{stock}, 'Y', '#{CURRENT_DATE}', '#{CURRENT_DATE}', '', '#{CURRENT_DATE}')")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def remove(prodID)
		begin
			Validation.new.checkValidInt(prodID)
			$db.execute("update products set prod_active = 'N' where prod_id = #{prodID}")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def modify (field, newValue, prodID)
		begin
			validation = Validation.new
			validation.checkValidInt(prodID)
			case field
				when "prod_name"
					validation.checkValidName(newValue)
					$db.execute("update products set #{field} = '#{newValue.upcase}' where prod_id = #{prodID}");
				when "prod_price"
					validation.checkValidPrice(newValue)
					$db.execute("update products set #{field} = '#{newValue}', price_last_upd_dt = '#{CURRENT_DATE}' where prod_id = #{prodID}");
				when "prod_stock"
					validation.checkValidInt(newValue)
					$db.execute("update products set #{field} = '#{newValue}', stock_last_upd_dt = '#{CURRENT_DATE}' where prod_id = #{prodID}");
				else
					raise RuntimeError, ERR_INVALID_ACTION, ERR_LOC_PROD_MOD
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def searchByName (name)
		begin
			return $db.execute("select * from products where prod_active = 'Y' and prod_name like '%#{name.upcase}%'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listAll
		begin
			return $db.execute("select * from products where prod_active = 'Y'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listOutOfStock
		begin
			return $db.execute("select * from products where prod_stock = 0 and prod_active = 'Y'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def addStock(prodID, stockToAdd)
		begin
			validation = Validation.new
			validation.checkValidInt(prodID)
			validation.checkValidInt(stockToAdd)
			currentStock = (($db.execute("select prod_stock from products where prod_id = #{prodID}"))[0]['prod_stock'])
			modify("prod_stock", currentStock + stockToAdd, prodID)
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def checkAvailStock (prodID, reqProdAmnt)
		validation = Validation.new
		validation.checkValidInt(prodID)
		validation.checkValidInt(reqProdAmnt)
		prodStock = ($db.execute("select prod_stock from products where prod_id = #{prodID}")[0]['prod_stock'])
		if prodStock < 0
			raise RuntimeError, "#{ERR_PROD_INV_STK} #{product['prod_id']}" , ERR_LOC_ORD_CRE
		end
		if prodStock < reqProdAmnt
			return false
		else
			return true
		end
	end
end