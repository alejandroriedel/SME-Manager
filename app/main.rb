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
	backupDB
	dbName = getDBCompleteName(DB_PATH,DB_NAME)
	setLogFileCompleteName(LOG_PATH)
	openDB(dbName)
	createTables
	GUIApp.new.main_loop
rescue => e
	writeLog("ERROR", e.class.to_s, e.message, e.backtrace.to_s)
end
