def load_cnfg_panel
############ PANELS ############
	panel = Panel.new(self)

############ BUTTONS ############
	btn_ok = Button.new(panel, -1, "SAVE / GUARDAR", Point.new(730, 460), Size.new(150, 30))

############ TEXT BOXES ############
	@txt_cli_name = TextCtrl.new(panel, -1, CLI_NAME, Point.new(300, 60), Size.new(290, 30))
	@txt_cli_cuit = TextCtrl.new(panel, -1, CLI_CUIT, Point.new(300, 100), Size.new(290, 30))
	@txt_cli_address = TextCtrl.new(panel, -1, CLI_ADD, Point.new(300, 140), Size.new(290, 30))
	@txt_cli_phone = TextCtrl.new(panel, -1, CLI_PHO, Point.new(300, 180), Size.new(290, 30))
	@txt_cli_logo = TextCtrl.new(panel, -1, CLI_LOGO, Point.new(300, 220), Size.new(290, 30))
	@txt_logo_path = TextCtrl.new(panel, -1, IMG_PATH, Point.new(300, 260), Size.new(290, 30))
	@txt_db_path = TextCtrl.new(panel, -1, DB_PATH, Point.new(300, 300), Size.new(290, 30))
	@txt_db_name = TextCtrl.new(panel, -1, DB_NAME, Point.new(300, 340), Size.new(290, 30))
	@txt_db_bk_days = TextCtrl.new(panel, -1, "#{DB_BK_DAYS}", Point.new(300, 380), Size.new(100, 30))
	@txt_log_path = TextCtrl.new(panel, -1, LOG_PATH, Point.new(300, 420), Size.new(290, 30))
	@txt_bill_path = TextCtrl.new(panel, -1, BILL_PATH, Point.new(300, 460), Size.new(290, 30))

############ LABELS ############
	StaticText.new(panel, -1, LBL_CNFG_LANG, Point.new(15,22), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_CMP_NM, Point.new(15,67), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_CMP_ID, Point.new(15,107), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_ADD, Point.new(15,147), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_PHO, Point.new(15,187), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_IMG, Point.new(15,227), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_IMG_PATH, Point.new(15,267), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_DB_PATH, Point.new(15,307), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_DB_NM, Point.new(15,347), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_DB_BK, Point.new(15,387), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_DAYS, Point.new(450,387), Size.new(150, 30))
	StaticText.new(panel, -1, LBL_CNFG_LOG_PATH, Point.new(15,427), Size.new(285, 30))
	StaticText.new(panel, -1, LBL_CNFG_BILL_PATH, Point.new(15,467), Size.new(285, 30))

############ RADIO BOXES ############
	lang_choices = ["ESP", "ENG"]
	@langs = RadioBox.new(panel,:label => "",:pos => [300, 5], :size => DEFAULT_SIZE, :choices => lang_choices, :major_dimension => 2,:style => RA_SPECIFY_COLS)

############ EVENTS ############
	evt_radiobox(@langs.get_id()) {|cmd_event| on_change_lang(cmd_event)}
	evt_button(btn_ok.get_id) { |event| btn_ok_click(event)}

	return panel
end

def on_change_lang(cmd_event)
	 @app_lang = cmd_event.string
end

def btn_ok_click(event)
	configFile = File.new(CNFG_FILE,"w")
	configFile.puts "APP_LANG = '#{@app_lang == nil ? 'ESP' : @app_lang}'"
	configFile.puts "DB_PATH = '#{@txt_db_path.get_value.strip}'"
	configFile.puts "DB_NAME = '#{@txt_db_name.get_value.strip}'"
	configFile.puts "DB_BK_DAYS = #{@txt_db_bk_days.get_value.strip}"
	configFile.puts "LOG_PATH = '#{@txt_log_path.get_value.strip}'"
	configFile.puts "BILL_PATH = '#{@txt_bill_path.get_value.strip}'"
	configFile.puts "IMG_PATH = '#{@txt_logo_path.get_value.strip}'"
	configFile.puts "CLI_NAME = '#{@txt_cli_name.get_value.strip}'"
	configFile.puts "CLI_CUIT = '#{@txt_cli_cuit.get_value.strip}'"
	configFile.puts "CLI_ADD = '#{@txt_cli_address.get_value.strip}'"
	configFile.puts "CLI_PHO = '#{@txt_cli_phone.get_value.strip}'"
	configFile.puts "CLI_LOGO = '#{@txt_cli_logo.get_value.strip}'"
	configFile.close

	Dir.mkdir(@txt_log_path.get_value.strip) if !FileTest.directory?(@txt_log_path.get_value.strip)
	Dir.mkdir(@txt_db_path.get_value.strip) if !FileTest.directory?(@txt_db_path.get_value.strip)
	Dir.mkdir(@txt_bill_path.get_value.strip) if !FileTest.directory?(@txt_bill_path.get_value.strip)
	Dir.mkdir(@txt_logo_path.get_value.strip) if !FileTest.directory?(@txt_logo_path.get_value.strip)

	Dialogs.new.showInfoDialog(LBL_INFO, WRN_NEED_RESTART)
end
