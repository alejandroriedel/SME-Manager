class Order

	attr_accessor

	def initialize

	end

	def create(custID, orderProducts, estDeliveryDt)
		begin
			validation = Validation.new
			validation.checkValidInt(custID)
			validation.checkValidProducts(orderProducts)
			validation.checkValidDate(estDeliveryDt)
			ordID = ($db.execute("select max(ord_id) from orders"))[0]['max(ord_id)']
			ordID = (ordID == nil ? 0 : ordID + 1)
			orderPrice = 0
			productOutOfStock = ""
			flagAvailStock = true
			flagProdNotAvailable = false
			orderProducts.each_value do |product|
				begin
					prodUnitPrice = ($db.execute("select prod_price from products where prod_id = #{product['prod_id']}"))[0]['prod_price']
				rescue => e
					raise RuntimeError, "#{ERR_PROD_NOT_FND} #{product['prod_id']}" , ERR_LOC_ORD_CRE
				end
				if prodUnitPrice <= 0
					raise RuntimeError, "#{ERR_PROD_INV_PRC} #{product['prod_id']}" , ERR_LOC_ORD_CRE
				end
				prodTotalPrice = product["prod_amnt"] * prodUnitPrice
				orderPrice += prodTotalPrice
				if !(flagAvailStock = Product.new.checkAvailStock(product['prod_id'], product["prod_amnt"]))
					if productOutOfStock == ""
						productOutOfStock = "#{product['prod_id']}"
					else
						productOutOfStock += ",#{product['prod_id']}"
					end
				end
			end
			if flagAvailStock
				$db.execute("insert into orders values(#{ordID}, '#{PEND_STATUS}', '#{custID}', #{orderPrice}, '#{CURRENT_DATE}', '#{CURRENT_DATE}', '#{estDeliveryDt}', '')")
				$db.execute("update customers set last_order_dt = '#{CURRENT_DATE}' where cust_id = #{custID}")

				orderProducts.each_value do |product|
					prodUnitPrice = ($db.execute("select prod_price from products where prod_id = #{product["prod_id"]}")[0]['prod_price'])
					prodTotalPrice = product["prod_amnt"] * prodUnitPrice
					newProdStock = ($db.execute("select prod_stock from products where prod_id = #{product['prod_id']}")[0]['prod_stock']) - product['prod_amnt']
					begin
						$db.execute("insert into order_details values(#{ordID}, #{product["prod_id"]}, #{product["prod_amnt"]}, #{prodUnitPrice})")
					rescue
						$db.execute("delete from orders where ord_id = #{ordID}")
						$db.execute("delete from order_details where ord_id = #{ordID}")
						raise RuntimeError, "#{ERR_ORD_DUPL_PROD}. ordID: #{ordID} prodID: #{product["prod_id"]}", ERR_LOC_ORD_CRE
					end
					$db.execute("update products set last_ordered_dt = '#{CURRENT_DATE}', prod_stock = #{newProdStock} where prod_id = #{product["prod_id"]}")
				end
			else
				raise RuntimeError, "#{ERR_PROD_OUT_STK} #{productOutOfStock}", ERR_LOC_ORD_CRE
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def updateStatus (ordID, newStatus, compDate)
		begin
			validation = Validation.new
			validation.checkValidInt(ordID)
			if canBeEdited(ordID)
				case newStatus
					when COMP_STATUS
						validation.checkValidDate(compDate)
						$db.execute("update orders set ord_status = '#{newStatus}', last_updated_dt = '#{CURRENT_DATE}', delivered_dt = '#{compDate}' where ord_id = #{ordID}")
					when CANC_STATUS
						$db.execute("update orders set ord_status = '#{newStatus}', last_updated_dt = '#{CURRENT_DATE}' where ord_id = #{ordID}")
					else
						raise RuntimeError, ERR_INVALID_ACTION, ERR_LOC_ORD_UPDST
				end
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def canBeEdited (ordID)
		Validation.new.checkValidInt(ordID)
		currentStatus = $db.execute("select ord_status from orders where ord_id = #{ordID}")[0]['ord_status']
		(raise RuntimeError, "#{ERR_CANT_MOD_ORD} #{ordID}" , ERR_LOC_ORD_UPDST) if currentStatus != PEND_STATUS
		return 0
	end

	def listAll
		begin
			return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listDetails (ordID)
		begin
			Validation.new.checkValidInt(ordID)
			return $db.execute("select p.prod_name, od.prod_amount, od.unit_price from orders o, order_details od, products p where o.ord_id = od.ord_id and p.prod_id = od.prod_id and od.ord_id = #{ordID};")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def modify (action, ordID, prodID, prodAmnt)
		begin
			validation = Validation.new
			validation.checkValidInt(ordID)
			validation.checkValidInt(prodID)
			validation.checkValidInt(prodAmnt) if action != LBL_REMOVE
			if canBeEdited(ordID)
				case action
					when LBL_REMOVE
						$db.execute("update products set prod_stock = ((select prod_amount from order_details where ord_id = #{ordID} and prod_id = #{prodID}) + (select prod_stock from products where prod_id = #{prodID})) where prod_id = #{prodID}")
						$db.execute("delete from order_details where ord_id = #{ordID} and prod_id = #{prodID}")
					when LBL_ADD
						if (Product.new.checkAvailStock(prodID, prodAmnt))
							begin
								$db.execute("insert into order_details values (#{ordID}, #{prodID}, #{prodAmnt}, (select prod_price from products where prod_id = #{prodID}))")
							rescue
								raise RuntimeError, "#{ERR_ORD_DUPL_PROD}. ordID: #{ordID} prodID: #{prodID}", ERR_LOC_ORD_MOD
							end
							$db.execute("update products set prod_stock = ((select prod_stock from products where prod_id = #{prodID}) - #{prodAmnt}), last_ordered_dt = '#{CURRENT_DATE}' where prod_id = #{prodID}")
						else
							raise RuntimeError, "#{ERR_PROD_OUT_STK} #{prodID}", ERR_LOC_ORD_MOD
						end
					when LBL_MOD_STK
						currProdAmnt = $db.execute("select prod_amount from order_details where ord_id = #{ordID} and prod_id = #{prodID}")[0]['prod_amount']
						if prodAmnt != currProdAmnt
							if prodAmnt > currProdAmnt
								missProdAmnt = prodAmnt - currProdAmnt
								if (Product.new.checkAvailStock(prodID, missProdAmnt))
									$db.execute("update products set prod_stock = ((select prod_stock from products where prod_id = #{prodID}) - #{missProdAmnt}) where prod_id = #{prodID}")
									$db.execute("update products set last_ordered_dt = '#{CURRENT_DATE}' where prod_id = #{prodID}")
								else
									raise RuntimeError, "#{ERR_PROD_OUT_STK} #{prodID}", ERR_LOC_ORD_MOD
								end
							else
								excProduct = currProdAmnt - prodAmnt
								$db.execute("update products set prod_stock = ((select prod_stock from products where prod_id = #{prodID}) + #{excProduct}) where prod_id = #{prodID}")
							end
							$db.execute("update order_details set prod_amount = #{prodAmnt} where ord_id = #{ordID} and prod_id = #{prodID}")
						end
					else
						raise RuntimeError, ERR_INVALID_ACTION, ERR_LOC_ORD_MOD
				end
				if $db.execute("select count(*) from order_details where ord_id = #{ordID}")[0]['count(*)'] > 0
					ordIncome = 0
					$db.execute("select * from order_details where ord_id = #{ordID}").each do |product|
						ordIncome += product['prod_amount'] * product['unit_price']
					end
					$db.execute("update orders set last_updated_dt = '#{CURRENT_DATE}', income = #{ordIncome} where ord_id = #{ordID}")
				else
					updateStatus(ordID, CANC_STATUS, nil)
				end
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
	
	def listByCust (custToSearch)
		begin
			return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and c.cust_name like '%#{custToSearch}%'")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listByDate (action, rangeStart, rangeStop, day, month, year)
		begin
			case action
				when LBL_RANGE
					return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.order_dt >= '#{rangeStart}' and o.order_dt <= '#{rangeStop}'")
				when LBL_DATE
					return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.order_dt = '#{year}-#{month}-#{day}'")
				when LBL_DAY
					return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.order_dt like '%-#{day}'")
				when LBL_MONTH
					return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.order_dt like '%-#{month}-%'")
				when LBL_YEAR
					return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.order_dt like '#{year}-%'")
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end

	def listByProd (prodToSearch)
		return $db.execute("select o.ord_id, o.ord_status, c.cust_name, o.income, o.order_dt, o.est_delivery_dt, o.delivered_dt from orders o, customers c where o.asoc_cust_id = c.cust_id and o.ord_id in (select distinct ord_id from order_details od, products p where od.prod_id = p.prod_id and p.prod_name like '%#{prodToSearch}%');")
	end

	def retrieve (ordID)
		begin
			Validation.new.checkValidInt(ordID)
			return $db.execute("select * from orders where ord_id = #{ordID}")
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
end
