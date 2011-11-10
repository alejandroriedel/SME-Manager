require './auxScripts/tableLoader'
require './config/config'
require './config/params'
require './lib/billing'
require './lib/customer'
require './lib/db'
require './lib/init_config'
require './lib/logger'
require './lib/order'
require './lib/product'
require './lib/validation'
require (RUBY_VERSION < '1.9' ? 'ftools' : 'fileutils')
require 'sqlite3'
require 'prawn'

describe do
	$currentDate = Time.now.strftime("%Y-%m-%d")
	$estDeliveryDt = Time.now.strftime("%Y-%m-") + ((Time.now.day + 2) < 10 ? "0#{(Time.now.day + 2)}" : (Time.now.day + 2).to_s)  
#---------------------------------------------------------------------------------
	it "10-Should load the proper config parameters & get complete paths for DB & Files" do
		logPath = LOG_PATH
		dbPath = DB_PATH
		dbName = DB_NAME

		logPath.should include("./log/")
		dbPath.should include("./db/")
		dbName.should include(".db")
	end

	it "20-Should generate log file name & path. Log file will be named with the current date (8 characters)" do
		setLogFileCompleteName(LOG_PATH)

		$logFileCompletePath.should include("./log/")
		$logFileCompletePath.should include("#{Time.now.day}")
		$logFileCompletePath.should include("#{Time.now.month}")
		$logFileCompletePath.should include("#{Time.now.year}")
		$logFileCompletePath.should include(".log")
		$logFileCompletePath.should have(LOG_PATH.length + 8 + "./log/".length).characters
	end

	it "30-Should generate database complete path including db name" do
		dbCompleteName = getDBCompleteName(DB_PATH,DB_NAME)

		dbCompleteName.should include("./db/")
		dbCompleteName.should include(DB_NAME)
		dbCompleteName.should include(".db")
	end

	it "40-Should open the DB. In case it doesn't exist it will create it. It should also close before finishing the program" do
		pending("Still need to find how to compare against Sqlite pointer. Should it be null after closing?")

		dbCompleteName = getDBCompleteName(DB_PATH,DB_NAME)

		openDB(dbCompleteName)

		$db.should != nil

		closeDB()

		$db.should == nil
	end

	it "50- Should create tables in case they don't exist" do
		dbCompleteName = getDBCompleteName(DB_PATH,DB_NAME)
		openDB(dbCompleteName)

		createTables()
		begin
			$db.execute("select * from customers")
			$db.execute("select * from products")
			$db.execute("select * from orders")
			$db.execute("select * from order_details")
			flag_error = false
		rescue
			flag_error = true
		end

		flag_error.should == false
	end

	it "55- Should open the log and write a test row" do
		setLogFileCompleteName(LOG_PATH)
		(File.delete($logFileCompletePath) if File.exists?($logFileCompletePath))

		writeLog("TEST", "Test entryClass", "Test entryMessage", "Test entryLocation")

		logFile = File.new($logFileCompletePath, "r")
		(logFile.gets).should include("Type: TEST Class: Test entryClass, Message: Test entryMessage, Location: Test entryLocation")
		logFile.close
	end

	it "58- Should backup the tables every DB_BK_DAYS" do
		backupDB

		allFiles = Dir.entries(DB_PATH)
		bkFiles = Array.new
		allFiles.each_index do |index|
			bkFiles.push(allFiles[index].gsub('.bk','')) if allFiles[index].include?(".bk")
		end
		bkFiles.length.should > 0
	end
#---------------------------------------------------------------------------------
	it "60- Should add customers to the tables" do
		if ($db.execute("select * from customers where cust_name = 'ALEJANDRO RIEDEL'").length > 0)
			$db.execute("delete from customers where cust_name = 'ALEJANDRO RIEDEL'")
		end
		
		$db.execute("select * from customers where cust_name = 'ALEJANDRO RIEDEL'").length.should == 0

		Customer.new.add("alejandro riedel", "puan 792", "3532-9686")

		$db.execute("select * from customers where cust_name = 'ALEJANDRO RIEDEL'").length.should == 1
	end

	it "70- Should update an existing customer" do
		custID = ($db.execute("select * from customers where cust_name = 'ALEJANDRO RIEDEL'"))[0]['cust_id']

		Customer.new.modify("cust_phone", "4632-7810", custID)
	
		($db.execute("select cust_phone from customers where cust_id = #{custID}"))[0]['cust_phone'].should == "4632-7810"
		($db.execute("select last_updated_dt from customers where cust_id = #{custID}"))[0]['last_updated_dt'].should == $currentDate
	end

	it "80- Should search customers by name" do
		row = Customer.new.searchByName("ALEJANDRO RIEDEL");

		row.length.should == 1;
	end

	it "85- Should retrieve a customer by its ID" do
		cust = Customer.new.retrieve(0)
		
		cust.length.should == 1
		cust[0]['cust_name'].should include("EUGENIA")
	end

	it "90- Should retrieve a list of all customers" do
		row = Customer.new.listAll()

		row.length.should > 0
	end

	it "100- Should delete an existing customer" do
		customer = $db.execute("select * from customers where cust_name = 'ALEJANDRO RIEDEL'")
		custID = customer[0]['cust_id']
		customer[0]['cust_active'].should == "Y"

		Customer.new.remove(custID)
		
		$db.execute("select cust_active from customers where cust_id = #{custID}")[0]['cust_active'].should == "N"
	end

	it "105- Should validate data before creating/modifying a customer" do
		customer = Customer.new

		errorMessage = nil
		begin
			customer.add("alejandro !1", "puan 792", "3532-9686")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_NAME)

		errorMessage = nil
		begin
			customer.add("al", "puan 792", "3532-9686")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_NAME)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "792", "3532-9686")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_ADDRESS)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "puan", "3532-9686")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_ADDRESS)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "puan 792", "a")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PHONE)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "puan 792", "352-7686")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PHONE)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "puan 792", "15-6041-432")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PHONE)

		errorMessage = nil
		begin
			customer.add("alejandro riedel", "puan 792", "156041432707")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PHONE)

		errorMessage = nil
		begin
			customer.modify("invalid_action", "4632-7810", 0)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_ACTION)
	end
#---------------------------------------------------------------------------------
	it "110- Should add products to the tables" do
		if ($db.execute("select * from products where prod_name like 'ARROZ%'").length > 0)
			$db.execute("delete from products where prod_name like 'ARROZ%'")
		end
		$db.execute("select * from products where prod_name = 'ARROZ'").length.should == 0

		Product.new.add("arroz", 4.15, 16)

		$db.execute("select * from products where prod_name = 'ARROZ'").length.should == 1
	end

	it "120- Should update an existing product and manage dates accordingly if needed" do
		product = Product.new
		prodID = ($db.execute("select * from products where prod_name like 'ARROZ%'"))[0]['prod_id']

		product.modify("prod_name", "arroz 5kg", prodID)
		
		($db.execute("select prod_name from products where prod_id = #{prodID}"))[0]['prod_name'].should == "ARROZ 5KG"

		product.modify("prod_stock", 50, prodID)
		
		($db.execute("select prod_stock from products where prod_id = #{prodID}"))[0]['prod_stock'].should == 50
		($db.execute("select stock_last_upd_dt from products where prod_id = #{prodID}"))[0]['stock_last_upd_dt'].should == $currentDate

		product.modify("prod_price", 35.5, prodID)
		
		($db.execute("select prod_price from products where prod_id = #{prodID}"))[0]['prod_price'].should == 35.5
		($db.execute("select price_last_upd_dt from products where prod_id = #{prodID}"))[0]['price_last_upd_dt'].should == $currentDate		
	end

	it "130- Should search products by name" do
		row = Product.new.searchByName("arroz");

		row.length.should > 0;
	end

	it "140- Should retrieve a list of all products" do
		row = Product.new.listAll()

		row.length.should > 0
	end

	it "150- Should list out of stock products" do
		row = Product.new.listOutOfStock()

		row_test = $db.execute("select * from products where prod_stock = 0")
		row.length.should == row_test.length
	end

	it "155- Should add stock to a product" do
		prodID = ($db.execute("select * from products where prod_name like 'ARROZ%'"))[0]['prod_id']

		Product.new.addStock(prodID, 10)
		
		(($db.execute("select prod_stock from products where prod_id = #{prodID}"))[0]['prod_stock']).should == 60
	end

	it "160- Should delete an existing product" do
		product = $db.execute("select * from products where prod_name like 'ARROZ%'")
		prodID = product[0]['prod_id']
		product[0]['prod_active'].should == "Y"

		Product.new.remove(prodID)

		$db.execute("select prod_active from products where prod_id = #{prodID}")[0]['prod_active'].should == "N"
	end

	it "165- Should validate data before creating/modifying a product" do
		product = Product.new

		errorMessage = nil
		begin
			product.add("arroz!", 4.15, 16)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_NAME)

		errorMessage = nil
		begin
			product.add("arroz", "4.1.5", 16)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_FLOAT)

		errorMessage = nil
		begin
			product.add("arroz", "4,15", 16)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_FLOAT)

		errorMessage = nil
		begin
			product.add("arroz", 0.0, 16)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PRICE)

		errorMessage = nil
		begin
			product.add("arroz", 4.15, "16a")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_INT)

		errorMessage = nil
		begin
			product.modify("invalid_action", 50, 0)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_ACTION)

		errorMessage = nil
		begin
			product.addStock(0, "m")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_INT)

	end
#---------------------------------------------------------------------------------
	it "170- Should open a new order of 1 product" do
		prevCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		orderProducts = { 0 => {"prod_id" => 0, "prod_amnt" => 1} }

		Order.new.create(0, orderProducts, $estDeliveryDt)
		
		currentCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		currentMaxOrderID = ($db.execute("select max(ord_id) from orders"))[0]['max(ord_id)']
		(currentCountOrders - prevCountOrders).should == 1
		$db.execute("select * from orders where ord_id = #{currentMaxOrderID}").length.should == 1
		$db.execute("select * from order_details where ord_id = #{currentMaxOrderID} and prod_id = 0").length.should == 1
		(($db.execute("select last_order_dt from customers where cust_id = 0"))[0]['last_order_dt']).should == $currentDate
		(($db.execute("select last_ordered_dt from products where prod_id = 0"))[0]['last_ordered_dt']).should == $currentDate
	end

	it "180- Should open a new order for 2 products" do
		prevCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		product1 = {"prod_id" => 0, "prod_amnt" => 1}
		product2 = {"prod_id" => 1, "prod_amnt" => 1}
		orderProducts = { 0 => product1, 1 => product2 }

		Order.new.create(0, orderProducts, $estDeliveryDt)
		
		currentCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		currentMaxOrderID = ($db.execute("select max(ord_id) from orders"))[0]['max(ord_id)']
		(currentCountOrders - prevCountOrders).should == 1
		$db.execute("select * from orders where ord_id = #{currentMaxOrderID}").length.should == 1
		$db.execute("select * from order_details where ord_id = #{currentMaxOrderID} and prod_id = 0").length.should == 1
		$db.execute("select * from order_details where ord_id = #{currentMaxOrderID} and prod_id = 1").length.should == 1
		(($db.execute("select last_order_dt from customers where cust_id = 0"))[0]['last_order_dt']).should == $currentDate
		(($db.execute("select last_ordered_dt from products where prod_id = 0"))[0]['last_ordered_dt']).should == $currentDate
		(($db.execute("select last_ordered_dt from products where prod_id = 1"))[0]['last_ordered_dt']).should == $currentDate
	end

	it "190- Should not create a new order if any of the included products has not enough stock" do
		prodID = ($db.execute("select max(prod_id) from products"))[0]['max(prod_id)']
		Product.new.modify("prod_stock", 1, prodID)
		prevCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		prevCountOrderDetailsID = ($db.execute("select count(*) from order_details")[0]['count(*)'])
		product1 = {"prod_id" => 0, "prod_amnt" => 5}
		product2 = {"prod_id" => prodID, "prod_amnt" => 3}
		orderProducts = { 0 => product1, 1 => product2 }

		begin
			Order.new.create(0, orderProducts, $estDeliveryDt)
		rescue => e
			errorMessage = e.message
		end

		errorMessage.should include(ERR_PROD_OUT_STK)
		currentCountOrders = ($db.execute("select count(*) from orders"))[0]['count(*)']
		currentCountOrderDetailsID = ($db.execute("select count(*) from order_details")[0]['count(*)'])
		(currentCountOrders - prevCountOrders).should == 0
		(currentCountOrderDetailsID - prevCountOrderDetailsID).should == 0		
	end

	it "200- Should substract product amount accordingly when an order is placed for that product" do
		prodID = ($db.execute("select max(prod_id) from products"))[0]['max(prod_id)']
		Product.new.modify("prod_stock", 10, prodID)
		orderProducts = { 0 => {"prod_id" => prodID, "prod_amnt" => 6} }

		Order.new.create(0, orderProducts, $estDeliveryDt)
		(($db.execute("select prod_stock from products where prod_id = #{prodID}"))[0]['prod_stock']).should == 4
	end

	it "210- Should update the status of an order. In case it's completed it should add the delivery date" do
		order = Order.new

		order.updateStatus(3, CANC_STATUS, nil)
		
		(($db.execute("select ord_status from orders where ord_id = 3"))[0]['ord_status']).should == CANC_STATUS

		order.updateStatus(4, COMP_STATUS, $currentDate)
		
		(($db.execute("select ord_status from orders where ord_id = 4"))[0]['ord_status']).should == COMP_STATUS
		(($db.execute("select delivered_dt from orders where ord_id = 4"))[0]['delivered_dt']).should == $currentDate
	end

	it "212- Should modify an order" do
		order = Order.new

		stockToAdd = $db.execute("select prod_amount from order_details where ord_id = 1 and prod_id = 0")[0]['prod_amount']
		currentStock = $db.execute("select prod_stock from products where prod_id = 0")[0]['prod_stock']
		order.modify(LBL_REMOVE, 1, 0, nil)
		$db.execute("select * from order_details where ord_id = 1 and prod_id = 0").length.should == 0
		$db.execute("select last_updated_dt from orders where ord_id = 1")[0]['last_updated_dt'].should == CURRENT_DATE
		$db.execute("select prod_stock from products where prod_id = 0")[0]['prod_stock'].should == stockToAdd + currentStock
		$db.execute("select income from orders where ord_id = 1")[0]['income'].should == 8.34

		$db.execute("update products set prod_active = 'Y' where prod_id = 2")
		order.modify(LBL_ADD, 0, 2, 2)
		$db.execute("select * from order_details where ord_id = 0 and prod_id = 2").length.should == 1
		$db.execute("select last_updated_dt from orders where ord_id = 1")[0]['last_updated_dt'].should == CURRENT_DATE
		$db.execute("select income from orders where ord_id = 0")[0]['income'].should == (4.23 + 35.5 * 2)

		order.modify(LBL_MOD_STK, 2, 0, 4)
		$db.execute("select prod_amount from order_details where ord_id = 2 and prod_id = 0")[0]['prod_amount'].should == 4
		$db.execute("select prod_stock from products where prod_id = 0")[0]['prod_stock'].should == 4
		$db.execute("select income from orders where ord_id = 2")[0]['income'].should == (4.23 * 4)
		$db.execute("select last_updated_dt from orders where ord_id = 2")[0]['last_updated_dt'].should == CURRENT_DATE
	end

	it "215- Should not update an order if it has been closed (delivered or cancelled)" do
		order = Order.new
		
		begin
			order.updateStatus(3, COMP_STATUS, $currentDate)
		rescue => e
			errorMessage = e.message
		end

		errorMessage.should include(ERR_CANT_MOD_ORD)

		errorMessage = nil
		begin
			order.updateStatus(4, CANC_STATUS, nil)
		rescue => e
			errorMessage = e.message
		end

		errorMessage.should include(ERR_CANT_MOD_ORD)

		errorMessage = nil
		begin
			order.modify(LBL_REMOVE, 3, 0, nil)
		rescue => e
			errorMessage = e.message
		end

		errorMessage.should include(ERR_CANT_MOD_ORD)	
	end

	it "215- Should retrieve an order by its ID" do
		ord = Order.new.retrieve(0)
		
		ord.length.should == 1
		ord[0]['asoc_cust_id'].should == 0
	end

	it "220- Should list all the orders" do
		row = Order.new.listAll()

		row.length.should > 0
	end
	
	it "225- Should list the details of a certain order" do
		order = Order.new

		row = order.listDetails(1)

		row.length.should > 0
	end

	it "230- Should list orders by customer" do
		row = Order.new.listByCust("JAS")
		
		row.length.should == 4
	end

	it "235- Should list orders that contain a specific product" do
		row = Order.new.listByProd("PAPEL")

		row.length.should == 3
	end

	it "240- Should list orders by range, date, day, month or year" do
		count = nil
		count = $db.execute("select count(*) from orders where order_dt like '%-01'")[0]['count(*)']
		row = Order.new.listByDate(LBL_DAY, nil, nil, "01", nil, nil)
		row.length.should == count

		count = nil
		count = $db.execute("select count(*) from orders where order_dt like '%-09-%'")[0]['count(*)']
		row = Order.new.listByDate(LBL_MONTH, nil, nil, nil, "09", nil)
		row.length.should == count

		count = nil
		count = $db.execute("select count(*) from orders where order_dt like '2011-%'")[0]['count(*)']
		row = Order.new.listByDate(LBL_YEAR, nil, nil, nil, nil, "2011")
		row.length.should == count

		count = nil
		count = $db.execute("select count(*) from orders where order_dt = '2011-09-01'")[0]['count(*)']
		row = Order.new.listByDate(LBL_DATE, nil, nil, "01", "09", "2011")
		row.length.should == count

		count = nil
		count = $db.execute("select count(*) from orders where order_dt >= '2011-08-20' and order_dt <= '2011-09-02'")[0]['count(*)']
		row = Order.new.listByDate(LBL_RANGE, "2011-08-20", "2011-09-02", nil, nil, nil)
		row.length.should == count
	end

	it "250- Should validate data before creating/modifying an order" do
		order = Order.new
		orderProducts = { 0 => {"prod_id" => 0, "prod_amnt" => 1} }

		errorMessage = nil
		begin
			order.modify("invalid_action", 0, 0, 1)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_ACTION)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-17-123")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_DATE_LEN)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "20110731--")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_DATE_FMT)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-13-21")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_MONTH)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-00-12")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_MONTH)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-02-29")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_DATE)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-04-31")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_DATE)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2011-09-30")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_PAST_DATE)

		errorMessage = nil
		begin
			order.create(0, orderProducts, "2000_02_29")
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_INVALID_DATE_CHAR)
	end
#---------------------------------------------------------------------------------
	it "260- Should check if it's a valid status to create a bill" do
		bill = Billing.new

		errorMessage = nil		
		begin
			bill.checkValidStatus(3)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should include(ERR_CANT_BILL_ORD)
		
		errorMessage = nil		
		begin
			bill.checkValidStatus(0)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should == nil
		
		errorMessage = nil		
		begin
			bill.checkValidStatus(4)
		rescue => e
			errorMessage = e.message
		end
		errorMessage.should == nil
	end
	
	it "270- Should generate the bill for a specific order" do
		order = Order.new
		ord = order.retrieve(4)
		ordDet = order.listDetails(4)
		cust = Customer.new.retrieve(ord[0]['asoc_cust_id'])
		billName = "#{LBL_BILL} - #{CLI_NAME} - #{LBL_BILL_ORDID} #{ord[0]['ord_id']}"
		billFile = "#{BILL_PATH}#{billName}.pdf"
		File.delete(billFile) if File.exists?(billFile)
		
		Billing.new.generateBill(cust, ord, ordDet)
		
		File.exists?(billFile).should == true
	end
#---------------------------------------------------------------------------------
	closeDB() if $db != nil
end
