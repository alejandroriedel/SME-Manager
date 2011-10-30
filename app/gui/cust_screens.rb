def load_cust_panel
############ PANELS ############
	panel = Panel.new(self)

############ BUTTONS ############
	#Button.new(Window parent, Integer id, String label = '', Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = "button")
	btn_list_all_cust = Button.new(panel, -1, BTN_RETR_ALL, Point.new(20, 460), Size.new(120, 30))
	btn_add_cust = Button.new(panel, -1, BTN_ADD, Point.new(150, 460), Size.new(120, 30))
	btn_mod_cust = Button.new(panel, -1, BTN_MOD, Point.new(280, 460), Size.new(120, 30))
	btn_rem_cust = Button.new(panel, -1, BTN_REM, Point.new(410, 460), Size.new(120, 30))
	btn_find_cust = Button.new(panel, -1, BTN_FIND, Point.new(540, 460), Size.new(120, 30))

############ GRIDS ############
	#Grid.new(Window parent,  Integer id, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = WANTS_CHARS, String name = PanelNameStr)
	@grd_cust = Grid.new(panel, -1, DEFAULT_POSITION, Size.new(1000,455))
	#Boolean create_grid(Integer numRows,  Integer numCols, Grid::GridSelectionModes selmode = Wx::Grid::GridSelectCells)
	@grd_cust.create_grid(100, 7)
	#set_default_cell_alignment(Integer horiz,  Integer vert)
	@grd_cust.set_default_cell_alignment(ALIGN_CENTRE, ALIGN_CENTRE)
	#set_col_label_value(Integer col,  String value)
	@grd_cust.set_col_label_value(0, LBL_ID)
	@grd_cust.set_col_label_value(1, LBL_NAME)
	@grd_cust.set_col_label_value(2, LBL_ADDRESS)
	@grd_cust.set_col_label_value(3, LBL_PHONE)
	@grd_cust.set_col_label_value(4, LBL_LASTORDERDT)
	@grd_cust.set_col_label_value(5, LBL_CREATEDDT)
	@grd_cust.set_col_label_value(6, LBL_LASTUPDATEDDT)
	#set_col_size(Integer col,  Integer width)
	@grd_cust.set_col_size(0, 45)
	@grd_cust.set_col_size(1, 225)
	@grd_cust.set_col_size(2, 225)
	@grd_cust.set_col_size(3, 95)
	@grd_cust.set_col_size(4, GRID_COL_WIDTH_DT)
	@grd_cust.set_col_size(5, GRID_COL_WIDTH_DT)
	@grd_cust.set_col_size(6, GRID_COL_WIDTH_DT)

############ TEXT BOXES ############
	#TextCtrl.new(Window parent,  Integer id,  String value = "", Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = TextCtrlNameStr)
	@txt_cust_find = TextCtrl.new(panel, -1, "", Point.new(670, 460), Size.new(150, 30))

############ EVENTS ############
	evt_button(btn_list_all_cust.get_id) { |event| btn_list_all_cust_click(event)}
	evt_button(btn_add_cust.get_id) { |event| btn_add_cust_click(event)}
	evt_button(btn_mod_cust.get_id) { |event| btn_mod_cust_click(event)}
	evt_button(btn_rem_cust.get_id) { |event| btn_rem_cust_click(event)}
	evt_button(btn_find_cust.get_id) { |event| btn_find_cust_click(event)}

	return panel
end

def btn_list_all_cust_click (event)
	begin
		writeCustGrid(Customer.new.listAll)
	rescue => e
		Dialogs.new.showErrorDialog(e.class.to_s, e.message)
	end
end

def btn_rem_cust_click (event)
	custToDelete = @grd_cust.get_selected_rows
	if custToDelete.length > 0
		customer = Customer.new
		custToDelete.each do |rowNum|
			custID = @grd_cust.get_cell_value(rowNum, 0)
			if (custID != "")
				del_cust_dialog = MessageDialog.new(nil,WRN_DEL_CUST_CONF,DEL_CUST_DIALOG,Wx::YES_NO | Wx::ICON_QUESTION)
				if del_cust_dialog.show_modal == Wx::ID_YES
					begin
						customer.remove(custID.to_i)
						btn_list_all_cust_click(nil)
					rescue => e
						Dialogs.new.showErrorDialog(e.class.to_s, e.message)
					end
				end
			else
				Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
				return
			end
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
	end
end

def btn_find_cust_click (event)
	@txt_cust_find.set_value(@txt_cust_find.get_value.strip)
	if !@txt_cust_find.is_empty
		begin
			writeCustGrid(Customer.new.searchByName(@txt_cust_find.get_value))
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_STR_INPUT)
		return
	end
end

def writeCustGrid (rows)
	@grd_cust.clear_grid
	rowNum = 0
	rows.each do |row|
		#set_cell_value(Integer row,  Integer col,  String s)
		@grd_cust.set_cell_value(rowNum, 0, "#{row['cust_id']}")
		@grd_cust.set_cell_value(rowNum, 1, "#{row['cust_name']}")
		@grd_cust.set_cell_value(rowNum, 2, "#{row['cust_address']}")
		@grd_cust.set_cell_value(rowNum, 3, "#{row['cust_phone']}")
		@grd_cust.set_cell_value(rowNum, 4, "#{row['last_order_dt']}")
		@grd_cust.set_cell_value(rowNum, 5, "#{row['created_dt']}")
		@grd_cust.set_cell_value(rowNum, 6, "#{row['last_updated_dt']}")
		#set_read_only(Integer row,  Integer col, Boolean isReadOnly = true)
		@grd_cust.set_read_only(rowNum, 0, true)
		@grd_cust.set_read_only(rowNum, 1, true)
		@grd_cust.set_read_only(rowNum, 2, true)
		@grd_cust.set_read_only(rowNum, 3, true)
		@grd_cust.set_read_only(rowNum, 4, true)
		@grd_cust.set_read_only(rowNum, 5, true)
		@grd_cust.set_read_only(rowNum, 6, true)
		#set_cell_alignment(Integer row,  Integer col,  Integer horiz, Integer vert)
		@grd_cust.set_cell_alignment(rowNum, 1, ALIGN_LEFT, ALIGN_CENTRE)
		@grd_cust.set_cell_alignment(rowNum, 2, ALIGN_LEFT, ALIGN_CENTRE)
		rowNum += 1
	end
end

def btn_add_cust_click (event)
	showAddEditCustDialog(ADD_CUST_DIALOG, nil, nil, nil, nil)
end

def btn_mod_cust_click (event)
	rowToModify = @grd_cust.get_selected_rows
	if rowToModify.length == 1
		custID = @grd_cust.get_cell_value(rowToModify[0], 0)
		if (custID != "")
			showAddEditCustDialog(MOD_CUST_DIALOG, custID.to_i, @grd_cust.get_cell_value(rowToModify[0], 1).strip, @grd_cust.get_cell_value(rowToModify[0], 2).strip, @grd_cust.get_cell_value(rowToModify[0], 3).strip)
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
			return
		end
	else
		if rowToModify.length == 0
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
			return
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_CNT_EDT_MLT_RW)
		end
	end
end

def showAddEditCustDialog (action, custID, name, address, phone)
	ad_ed_cust_dialog = Dialog.new(@panel_cust, -1, action, Point.new(50,50), (RUBY_PLATFORM.include?("linux") ? Size.new(450, 145) : Size.new(470, 180)))
	#StaticText.new(Window parent,  Integer id,  String label, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, String name = "staticText")
	StaticText.new(ad_ed_cust_dialog, -1, LBL_NAME, Point.new(15,12), Size.new(130, 30))
	StaticText.new(ad_ed_cust_dialog, -1, LBL_ADDRESS, Point.new(15,47), Size.new(130, 30))
	StaticText.new(ad_ed_cust_dialog, -1, LBL_PHONE, Point.new(15,82), Size.new(130, 30))
	txt_ad_ed_cust_dialog_name = TextCtrl.new(ad_ed_cust_dialog, -1, "", Point.new(145, 5), Size.new(300, 30))
	txt_ad_ed_cust_dialog_address = TextCtrl.new(ad_ed_cust_dialog, -1, "", Point.new(145, 40), Size.new(300, 30))
	txt_ad_ed_cust_dialog_phone = TextCtrl.new(ad_ed_cust_dialog, -1, "", Point.new(145, 75), Size.new(300, 30))
	btn_ad_ed_cust_dialog_ok = Button.new(ad_ed_cust_dialog, -1, BTN_OK, Point.new(100, 110), Size.new(120, 30))
	btn_ad_ed_cust_dialog_can = Button.new(ad_ed_cust_dialog, -1, BTN_CANCEL, Point.new(250, 110), Size.new(120, 30))
	ad_ed_cust_dialog.set_affirmative_id(btn_ad_ed_cust_dialog_ok.get_id)
	ad_ed_cust_dialog.set_escape_id(btn_ad_ed_cust_dialog_can.get_id)

	if action == MOD_CUST_DIALOG
		txt_ad_ed_cust_dialog_name.set_value(name)
		txt_ad_ed_cust_dialog_address.set_value(address)
		txt_ad_ed_cust_dialog_phone.set_value(phone)
	end

	if ad_ed_cust_dialog.show_modal == btn_ad_ed_cust_dialog_ok.get_id
		begin
			validation = Validation.new
			validation.guiCheckValidString(txt_ad_ed_cust_dialog_name.get_value.strip)
			validation.guiCheckValidString(txt_ad_ed_cust_dialog_address.get_value.strip)
			validation.guiCheckValidString(txt_ad_ed_cust_dialog_phone.get_value.strip)
			customer = Customer.new
			case action
				when ADD_CUST_DIALOG
					customer.add(txt_ad_ed_cust_dialog_name.get_value.strip, txt_ad_ed_cust_dialog_address.get_value.strip, txt_ad_ed_cust_dialog_phone.get_value.strip)
				when MOD_CUST_DIALOG
					customer.modify("cust_name", txt_ad_ed_cust_dialog_name.get_value.strip, custID) if txt_ad_ed_cust_dialog_name.is_modified
					customer.modify("cust_address", txt_ad_ed_cust_dialog_address.get_value.strip, custID) if txt_ad_ed_cust_dialog_address.is_modified
					customer.modify("cust_phone", txt_ad_ed_cust_dialog_phone.get_value.strip, custID) if txt_ad_ed_cust_dialog_phone.is_modified
			end
			btn_list_all_cust_click(nil)
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	end
end

