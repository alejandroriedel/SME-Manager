require 'rubygems' if RUBY_VERSION < '1.9'
require 'sqlite3'
require (RUBY_VERSION < '1.9' ? 'ftools' : 'fileutils')
require 'prawn'
require 'wx'
include Wx

require './config/config'
require './config/params'
require './gui/about_screen'
require './gui/cust_screens'
require './gui/config_screen.rb'
require './gui/dialogs'
require './gui/gui'
require './gui/main_screen'
require './gui/ord_screens'
require './gui/prod_screens'
require './lib/billing'
require './lib/customer'
require './lib/db'
require './lib/init_config'
require './lib/logger'
require './lib/order'
require './lib/product'
require './lib/validation'

begin
	Dir.mkdir("./log") if !FileTest.directory?("./log")
	Dir.mkdir("./db") if !FileTest.directory?("./db")
	Dir.mkdir("./img") if !FileTest.directory?("./img")
	Dir.mkdir("./bill") if !FileTest.directory?("./bill")
	setLogFileCompleteName(LOG_PATH)
	dbName = getDBCompleteName(DB_PATH,DB_NAME)		
	openDB(dbName)
	createTables
	backupDB
	GUIApp.new.main_loop
rescue => e
	writeLog("ERROR", e.class.to_s, e.message, e.backtrace.to_s)
end
