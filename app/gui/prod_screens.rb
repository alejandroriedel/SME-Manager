def load_prod_panel
############ PANELS ############
	panel = Panel.new(self)

############ BUTTONS ############
	#Button.new(Window parent, Integer id, String label = '', Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = "button")
	btn_list_all_prod = Button.new(panel, -1, BTN_RETR_ALL, Point.new(20, 460), Size.new(110, 30))
	btn_add_prod = Button.new(panel, -1, BTN_ADD, Point.new(140, 460), Size.new(110, 30))
	btn_mod_prod = Button.new(panel, -1, BTN_MOD, Point.new(260, 460), Size.new(110, 30))
	btn_rem_prod = Button.new(panel, -1, BTN_REM, Point.new(380, 460), Size.new(110, 30))
	btn_list_oos_prod = Button.new(panel, -1, BTN_RETR_OOS, Point.new(500, 460), Size.new(110, 30))
	btn_add_sto_prod = Button.new(panel, -1, BTN_ADD_STO, Point.new(620, 460), Size.new(110, 30))
	btn_find_prod = Button.new(panel, -1, BTN_FIND, Point.new(740, 460), Size.new(110, 30))

############ GRIDS ############
	#Grid.new(Window parent,  Integer id, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = WANTS_CHARS, String name = PanelNameStr)
	@grd_prod = Grid.new(panel, -1, DEFAULT_POSITION, Size.new(1000,455))
	#Boolean create_grid(Integer numRows,  Integer numCols, Grid::GridSelectionModes selmode = Wx::Grid::GridSelectCells)
	@grd_prod.create_grid(100, 8)
	#set_default_cell_alignment(Integer horiz,  Integer vert)
	@grd_prod.set_default_cell_alignment(ALIGN_CENTRE, ALIGN_CENTRE)
	#set_col_label_value(Integer col,  String value)
	@grd_prod.set_col_label_value(0, LBL_ID)
	@grd_prod.set_col_label_value(1, LBL_NAME)
	@grd_prod.set_col_label_value(2, LBL_PRICE)
	@grd_prod.set_col_label_value(3, LBL_STOCK)
	@grd_prod.set_col_label_value(4, LBL_PRCLSTUPDDT)
	@grd_prod.set_col_label_value(5, LBL_STKLSTUPDDT)
	@grd_prod.set_col_label_value(6, LBL_LASTORDERDT)
	@grd_prod.set_col_label_value(7, LBL_CREATEDDT)
	#set_col_size(Integer col,  Integer width)
	@grd_prod.set_col_size(0, 45)
	@grd_prod.set_col_size(1, 265)
	@grd_prod.set_col_size(2, 90)
	@grd_prod.set_col_size(3, 90)
	@grd_prod.set_col_size(4, GRID_COL_WIDTH_DT)
	@grd_prod.set_col_size(5, GRID_COL_WIDTH_DT)
	@grd_prod.set_col_size(6, GRID_COL_WIDTH_DT)
	@grd_prod.set_col_size(7, GRID_COL_WIDTH_DT)

############ TEXT BOXES ############
	#TextCtrl.new(Window parent,  Integer id,  String value = "", Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = TextCtrlNameStr)
	@txt_prod_find = TextCtrl.new(panel, -1, "", Point.new(860, 460), Size.new(140, 30))

############ EVENTS ############
	evt_button(btn_list_all_prod.get_id) { |event| btn_list_all_prod_click(event)}
	evt_button(btn_add_prod.get_id) { |event| btn_add_prod_click(event)}
	evt_button(btn_mod_prod.get_id) { |event| btn_mod_prod_click(event)}
	evt_button(btn_rem_prod.get_id) { |event| btn_rem_prod_click(event)}
	evt_button(btn_find_prod.get_id) { |event| btn_find_prod_click(event)}
	evt_button(btn_list_oos_prod.get_id) { |event| btn_list_oos_prod_click(event)}
	evt_button(btn_add_sto_prod.get_id) { |event| btn_add_sto_prod_click(event)}

	return panel
end

def btn_list_all_prod_click (event)
	begin
		writeProdGrid(Product.new.listAll)
	rescue => e
		Dialogs.new.showErrorDialog(e.class.to_s, e.message)
	end
end

def btn_rem_prod_click (event)
	prodToDelete = @grd_prod.get_selected_rows
	if prodToDelete.length > 0
		product = Product.new
		prodToDelete.each do |rowNum|
			prodID = @grd_prod.get_cell_value(rowNum, 0)
			if (prodID != "")
				del_prod_dialog = MessageDialog.new(nil,WRN_DEL_PROD_CONF,DEL_PROD_DIALOG,Wx::YES_NO | Wx::ICON_QUESTION)
				if del_prod_dialog.show_modal == Wx::ID_YES
					begin
						product.remove(prodID.to_i)
						btn_list_all_prod_click(nil)
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

def btn_find_prod_click (event)
	@txt_prod_find.set_value(@txt_prod_find.get_value.strip)
	if !@txt_prod_find.is_empty
		begin
			writeProdGrid(Product.new.searchByName(@txt_prod_find.get_value))
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR,  ERR_GUI_NO_STR_INPUT)
		return
	end
end

def writeProdGrid (rows)
	@grd_prod.clear_grid
	rowNum = 0
	rows.each do |row|
		#set_cell_value(Integer row,  Integer col,  String s)
		@grd_prod.set_cell_value(rowNum, 0, "#{row['prod_id']}")
		@grd_prod.set_cell_value(rowNum, 1, "#{row['prod_name']}")
		@grd_prod.set_cell_value(rowNum, 2, "#{row['prod_price']}")
		@grd_prod.set_cell_value(rowNum, 3, "#{row['prod_stock']}")
		@grd_prod.set_cell_value(rowNum, 4, "#{row['price_last_upd_dt']}")
		@grd_prod.set_cell_value(rowNum, 5, "#{row['stock_last_upd_dt']}")
		@grd_prod.set_cell_value(rowNum, 6, "#{row['last_ordered_dt']}")
		@grd_prod.set_cell_value(rowNum, 7, "#{row['created_dt']}")
		#set_read_only(Integer row,  Integer col, Boolean isReadOnly = true)
		@grd_prod.set_read_only(rowNum, 0, true)
		@grd_prod.set_read_only(rowNum, 1, true)
		@grd_prod.set_read_only(rowNum, 2, true)
		@grd_prod.set_read_only(rowNum, 3, true)
		@grd_prod.set_read_only(rowNum, 4, true)
		@grd_prod.set_read_only(rowNum, 5, true)
		@grd_prod.set_read_only(rowNum, 6, true)
		@grd_prod.set_read_only(rowNum, 7, true)
		#set_cell_alignment(Integer row,  Integer col,  Integer horiz, Integer vert)
		@grd_prod.set_cell_alignment(rowNum, 1, ALIGN_LEFT, ALIGN_CENTRE)
		rowNum += 1
	end
end

def btn_add_prod_click (event)
	showAddEditProdDialog(ADD_PROD_DIALOG, nil, nil, nil, nil)
end

def btn_mod_prod_click (event)
	rowToModify = @grd_prod.get_selected_rows
	if rowToModify.length == 1
		prodID = @grd_prod.get_cell_value(rowToModify[0], 0)
		if (prodID != "")
			showAddEditProdDialog(MOD_PROD_DIALOG, prodID.to_i, @grd_prod.get_cell_value(rowToModify[0], 1).strip, @grd_prod.get_cell_value(rowToModify[0], 2).strip, @grd_prod.get_cell_value(rowToModify[0], 3).strip)
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

def showAddEditProdDialog (action, prodID, name, price, stock)
	ad_ed_prod_dialog = Dialog.new(@panel_prod, -1, action, Point.new(50,50), (RUBY_PLATFORM.include?("linux") ? Size.new(450, 145) : Size.new(470, 180)))
	#StaticText.new(Window parent,  Integer id,  String label, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, String name = "staticText")
	StaticText.new(ad_ed_prod_dialog, -1, LBL_NAME, Point.new(15,12), Size.new(130, 30))
	StaticText.new(ad_ed_prod_dialog, -1, LBL_PRICE, Point.new(15,47), Size.new(130, 30))
	StaticText.new(ad_ed_prod_dialog, -1, LBL_STOCK, Point.new(15,82), Size.new(130, 30))
	txt_ad_ed_prod_dialog_name = TextCtrl.new(ad_ed_prod_dialog, -1, "", Point.new(145, 5), Size.new(300, 30))
	txt_ad_ed_prod_dialog_price = TextCtrl.new(ad_ed_prod_dialog, -1, "", Point.new(145, 40), Size.new(300, 30))
	txt_ad_ed_prod_dialog_stock = TextCtrl.new(ad_ed_prod_dialog, -1, "", Point.new(145, 75), Size.new(300, 30))
	btn_ad_ed_prod_dialog_ok = Button.new(ad_ed_prod_dialog, -1, BTN_OK, Point.new(100, 110), Size.new(120, 30))
	btn_ad_ed_prod_dialog_can = Button.new(ad_ed_prod_dialog, -1, BTN_CANCEL, Point.new(250, 110), Size.new(120, 30))
	ad_ed_prod_dialog.set_affirmative_id(btn_ad_ed_prod_dialog_ok.get_id)
	ad_ed_prod_dialog.set_escape_id(btn_ad_ed_prod_dialog_can.get_id)

	if action == MOD_PROD_DIALOG
		txt_ad_ed_prod_dialog_name.set_value(name)
		txt_ad_ed_prod_dialog_price.set_value(price)
		txt_ad_ed_prod_dialog_stock.set_value(stock)
	end

	if ad_ed_prod_dialog.show_modal == btn_ad_ed_prod_dialog_ok.get_id
		begin
			validation = Validation.new
			validation.guiCheckValidString(txt_ad_ed_prod_dialog_name.get_value.strip)
			validation.guiCheckValidFloat(txt_ad_ed_prod_dialog_price.get_value.strip)
			validation.guiCheckValidInt(txt_ad_ed_prod_dialog_stock.get_value.strip)
			product = Product.new
			case action
				when ADD_PROD_DIALOG
					product.add(txt_ad_ed_prod_dialog_name.get_value.strip, txt_ad_ed_prod_dialog_price.get_value.strip.to_f, txt_ad_ed_prod_dialog_stock.get_value.strip.to_i)
				when MOD_PROD_DIALOG
					product.modify("prod_name", txt_ad_ed_prod_dialog_name.get_value.strip, prodID) if txt_ad_ed_prod_dialog_name.is_modified
					product.modify("prod_price", txt_ad_ed_prod_dialog_price.get_value.strip.to_f, prodID) if txt_ad_ed_prod_dialog_price.is_modified
					product.modify("prod_stock", txt_ad_ed_prod_dialog_stock.get_value.strip.to_i, prodID) if txt_ad_ed_prod_dialog_stock.is_modified
			end
			btn_list_all_prod_click(nil)
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	end
end

def btn_list_oos_prod_click (event)
	begin
		writeProdGrid(Product.new.listOutOfStock)
	rescue => e
		Dialogs.new.showErrorDialog(e.class.to_s, e.message)
	end
end

def btn_add_sto_prod_click (event)
	rowToModify = @grd_prod.get_selected_rows
	if rowToModify.length == 1
		prodID = @grd_prod.get_cell_value(rowToModify[0], 0)
		if (prodID != "")
			as_dialog = Dialog.new(@panel_prod, -1, ADD_STOCK_DIALOG, Point.new(5,5), (RUBY_PLATFORM.include?("linux") ? Size.new(300, 135) : Size.new(330, 180)))
			StaticText.new(as_dialog, -1, LBL_NAME, Point.new(15,12), Size.new(130, 30))
			StaticText.new(as_dialog, -1, LBL_STOCK_TO_ADD, Point.new(15,67), Size.new(130, 30))
			StaticText.new(as_dialog, -1, @grd_prod.get_cell_value(rowToModify[0], 1), Point.new(155,12), Size.new(140, 30))
			txt_as_dialog_stock = TextCtrl.new(as_dialog, -1, "", Point.new(155, 60), Size.new(140, 30))
			btn_as_dialog_ok = Button.new(as_dialog, -1, BTN_OK, Point.new(20, 100), Size.new(120, 30))
			btn_as_dialog_can = Button.new(as_dialog, -1, BTN_CANCEL, Point.new(160, 100), Size.new(120, 30))
			as_dialog.set_affirmative_id(btn_as_dialog_ok.get_id)
			as_dialog.set_escape_id(btn_as_dialog_can.get_id)

			if as_dialog.show_modal == btn_as_dialog_ok.get_id
				begin
					Validation.new.guiCheckValidInt(txt_as_dialog_stock.get_value.strip)
					Product.new.addStock(prodID.to_i, txt_as_dialog_stock.get_value.strip.to_i)
					btn_list_all_prod_click(nil)
				rescue => e
					Dialogs.new.showErrorDialog(e.class.to_s, e.message)
				end
			end
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

