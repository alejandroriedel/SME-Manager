def openDB(dbFile)
	begin
		$db = SQLite3::Database.new(dbFile)
		$db.results_as_hash = true
	rescue => e
		writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
		raise
	end
end

def createTables
	begin
		$db.execute("create table if not exists customers (cust_id integer primary key, cust_name text, cust_address text, cust_phone text, cust_active text, last_order_dt text, created_dt text, last_updated_dt text)");
		$db.execute("create table if not exists products (prod_id integer primary key, prod_name text, prod_price real, prod_stock integer, prod_active text, price_last_upd_dt text, stock_last_upd_dt text, last_ordered_dt text, created_dt text)")
		$db.execute("create table if not exists orders (ord_id integer primary key, ord_status text, asoc_cust_id integer, income real, order_dt text, last_updated_dt text, est_delivery_dt text, delivered_dt text)")
		$db.execute("create table if not exists order_details (ord_id integer, prod_id integer, prod_amount integer, unit_price real, primary key (ord_id, prod_id))")
	rescue => e
		writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
		raise
	end
end

def closeDB
	begin
		$db.close
	rescue => e
		writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
		raise
	end
end
