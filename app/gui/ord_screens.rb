def load_ord_panel
############ PANELS ############
	panel = Panel.new(self)

############ BUTTONS ############
	#Button.new(Window parent, Integer id, String label = '', Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = "button")
	btn_list_all_ord = Button.new(panel, -1, BTN_RETR_ALL, Point.new(20, 425), Size.new(120, 30))
	btn_list_day_ord = Button.new(panel, -1, BTN_RETR_DAY, Point.new(150, 425), Size.new(120, 30))
	btn_list_month_ord = Button.new(panel, -1, BTN_RETR_MNTH, Point.new(280, 425), Size.new(120, 30))
	btn_list_year_ord = Button.new(panel, -1, BTN_RETR_YEAR, Point.new(410, 425), Size.new(120, 30))
	btn_list_range_ord = Button.new(panel, -1, BTN_RETR_RNG, Point.new(540, 425), Size.new(120, 30))
	btn_list_date_ord = Button.new(panel, -1, BTN_RETR_DT, Point.new(670, 425), Size.new(120, 30))
	btn_cre_ord = Button.new(panel, -1, BTN_CRE, Point.new(20, 460), Size.new(120, 30))
	btn_mod_ord = Button.new(panel, -1, BTN_MOD, Point.new(150, 460), Size.new(120, 30))
	btn_can_ord = Button.new(panel, -1, BTN_CANC_ST, Point.new(280, 460), Size.new(120, 30))
	btn_comp_ord = Button.new(panel, -1, BTN_COMP_ST, Point.new(410, 460), Size.new(120, 30))
	btn_list_cust_ord = Button.new(panel, -1, BTN_RETR_CUST, Point.new(540, 460), Size.new(120, 30))
	btn_list_prod_ord = Button.new(panel, -1, BTN_RETR_PROD, Point.new(670, 460), Size.new(120, 30))
	btn_list_det_ord = Button.new(panel, -1, BTN_RETR_DET, Point.new(880, 260), Size.new(120, 30))
	btn_gen_ord_bill = Button.new(panel, -1, BTN_GEN_BILL, Point.new(880, 295), Size.new(120, 30))

############ GRIDS ############
	#Grid.new(Window parent,  Integer id, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = WANTS_CHARS, String name = PanelNameStr)
	@grd_ord = Grid.new(panel, -1, DEFAULT_POSITION, Size.new(1000,250))
	@grd_ord_det = Grid.new(panel, -1, Point.new(0,255), Size.new(875,165))
	#Boolean create_grid(Integer numRows,  Integer numCols, Grid::GridSelectionModes selmode = Wx::Grid::GridSelectCells)
	@grd_ord.create_grid(100, 7)
	@grd_ord_det.create_grid(15, 3)
	#set_default_cell_alignment(Integer horiz,  Integer vert)
	@grd_ord.set_default_cell_alignment(ALIGN_CENTRE, ALIGN_CENTRE)
	@grd_ord_det.set_default_cell_alignment(ALIGN_CENTRE, ALIGN_CENTRE)
	#set_col_label_value(Integer col,  String value)
	@grd_ord.set_col_label_value(0, LBL_ID)
	@grd_ord.set_col_label_value(1, LBL_STATUS)
	@grd_ord.set_col_label_value(2, LBL_CUSTNAME)
	@grd_ord.set_col_label_value(3, LBL_INCOME)
	@grd_ord.set_col_label_value(4, LBL_ORDERDT)
	@grd_ord.set_col_label_value(5, LBL_ESTDELIVERYDT)
	@grd_ord.set_col_label_value(6, LBL_DELIVERYDT)
	@grd_ord_det.set_col_label_value(0, LBL_PRODNAME)
	@grd_ord_det.set_col_label_value(1, LBL_AMOUNT)
	@grd_ord_det.set_col_label_value(2, LBL_UNITPRC)
	#set_col_size(Integer col,  Integer width)
	@grd_ord.set_col_size(0, 45)
	@grd_ord.set_col_size(1, 160)
	@grd_ord.set_col_size(2, 285)
	@grd_ord.set_col_size(3, 100)
	@grd_ord.set_col_size(4, GRID_COL_WIDTH_DT)
	@grd_ord.set_col_size(5, GRID_COL_WIDTH_DT)
	@grd_ord.set_col_size(6, GRID_COL_WIDTH_DT)
	@grd_ord_det.set_col_size(0, 565)
	@grd_ord_det.set_col_size(1, 100)
	@grd_ord_det.set_col_size(2, 100)
	#set_selection_mode(Integer selmode)
	@grd_ord.set_selection_mode(Wx::Grid::GridSelectRows)

############ TEXT BOXES ############
	#TextCtrl.new(Window parent,  Integer id,  String value = "", Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = TextCtrlNameStr)
	@txt_ord_find = TextCtrl.new(panel, -1, "", Point.new(800, 460), Size.new(150, 30))

############ EVENTS ############
	evt_button(btn_list_all_ord.get_id) { |event| btn_list_all_ord_click(event)}
	evt_button(btn_list_det_ord.get_id) { |event| btn_list_det_ord_click(event)}
	evt_button(btn_cre_ord.get_id) { |event| btn_cre_ord_click(event)}
	evt_button(btn_mod_ord.get_id) { |event| btn_mod_ord_click(event)}
	evt_button(btn_can_ord.get_id) { |event| btn_can_ord_click(event)}
	evt_button(btn_comp_ord.get_id) { |event| btn_comp_ord_click(event)}
	evt_button(btn_list_day_ord.get_id) { |event| btn_list_day_ord_click(event)}
	evt_button(btn_list_month_ord.get_id) { |event| btn_list_month_ord_click(event)}
	evt_button(btn_list_year_ord.get_id) { |event| btn_list_year_ord_click(event)}
	evt_button(btn_list_range_ord.get_id) { |event| btn_list_range_ord_click(event)}
	evt_button(btn_list_date_ord.get_id) { |event| btn_list_date_ord_click(event)}
	evt_button(btn_list_cust_ord.get_id) { |event| btn_list_cust_ord_click(event)}
	evt_button(btn_list_prod_ord.get_id) { |event| btn_list_prod_ord_click(event)}
	evt_button(btn_gen_ord_bill.get_id) { |event| btn_gen_ord_bill_click(event)}

	return panel
end

def btn_list_all_ord_click (event)
	begin
		writeOrdGrid(Order.new.listAll)
	rescue => e
		Dialogs.new.showErrorDialog(e.class.to_s, e.message)
	end
end

def btn_cre_ord_click (event)
	custRows = Customer.new.listAll
	customers = Array.new
	custRows.each do |row|
		customers.push(row['cust_name'])
	end
	prodRows = Product.new.listAll
	products = Array.new
	prodRows.each do |row|
		products.push(row['prod_name'])
	end

	new_ord_dialog = Dialog.new(@panel_cust, -1, CRE_ORD_DIALOG, Point.new(5,5), (RUBY_PLATFORM.include?("linux") ? Size.new(580, 430) : Size.new(600, 460)))
	#StaticText.new(Window parent,  Integer id,  String label, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = 0, String name = "staticText")
	StaticText.new(new_ord_dialog, -1, LBL_CUSTNAME, Point.new(15,12), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_ESTDELIVERYDT, Point.new(390,12), Size.new(75, 25))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,47), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,82), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,117), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,152), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,187), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,222), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,257), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,292), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,327), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_PRODNAME, Point.new(15,362), Size.new(110, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,47), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,82), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,117), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,152), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,187), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,222), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,257), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,292), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,327), Size.new(70, 30))
	StaticText.new(new_ord_dialog, -1, LBL_AMOUNT, Point.new(465,362), Size.new(70, 30))
	cmb_new_ord_dialog_custname = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 5), Size.new(250, 30), customers)
	cmb_new_ord_dialog_prod0 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 40), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod1 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 75), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod2 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 110), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod3 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 145), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod4 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 180), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod5 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 215), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod6 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 250), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod7 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 285), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod8 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 320), Size.new(300, 30), products)
	cmb_new_ord_dialog_prod9 = ComboBox.new(new_ord_dialog, -1, "", Point.new(125, 355), Size.new(300, 30), products)
	#DatePickerCtrl.new(Window parent,  Integer id, DateTime dt = DefaultDateTime, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = DP_DEFAULT | DP_SHOWCENTURY, Validator validator = DEFAULT_VALIDATOR, String name = "datectrl")
	dp_new_ord_dialog_deliverydt = DatePickerCtrl.new(new_ord_dialog, -1, Time.now, Point.new(465, 5), Size.new(110, 30))
	txt_new_ord_dialog_stock0 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 40), Size.new(35, 30))
	txt_new_ord_dialog_stock1 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 75), Size.new(35, 30))
	txt_new_ord_dialog_stock2 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 110), Size.new(35, 30))
	txt_new_ord_dialog_stock3 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 145), Size.new(35, 30))
	txt_new_ord_dialog_stock4 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 180), Size.new(35, 30))
	txt_new_ord_dialog_stock5 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 215), Size.new(35, 30))
	txt_new_ord_dialog_stock6 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 250), Size.new(35, 30))
	txt_new_ord_dialog_stock7 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 285), Size.new(35, 30))
	txt_new_ord_dialog_stock8 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 320), Size.new(35, 30))
	txt_new_ord_dialog_stock9 = TextCtrl.new(new_ord_dialog, -1, "", Point.new(540, 355), Size.new(35, 30))
	btn_new_ord_dialog_ok = Button.new(new_ord_dialog, -1, BTN_OK, Point.new(113, 395), Size.new(120, 30))
	btn_new_ord_dialog_can = Button.new(new_ord_dialog, -1, BTN_CANCEL, Point.new(336, 395), Size.new(120, 30))
	new_ord_dialog.set_affirmative_id(btn_new_ord_dialog_ok.get_id)
	new_ord_dialog.set_escape_id(btn_new_ord_dialog_can.get_id)

	if new_ord_dialog.show_modal == btn_new_ord_dialog_ok.get_id
		if cmb_new_ord_dialog_custname.get_value != ""
			orderProductsIndex = 0
			orderProducts = Hash.new
			if cmb_new_ord_dialog_prod0.get_value != "" && txt_new_ord_dialog_stock0.get_value.strip != ""
				product0 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod0.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock0.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product0 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod1.get_value != "" && txt_new_ord_dialog_stock1.get_value.strip != ""
				product1 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod1.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock1.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product1 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod2.get_value != "" && txt_new_ord_dialog_stock2.get_value.strip != ""
				product2 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod2.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock2.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product2 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod3.get_value != "" && txt_new_ord_dialog_stock3.get_value.strip != ""
				product3 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod3.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock3.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product3 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod4.get_value != "" && txt_new_ord_dialog_stock4.get_value.strip != ""
				product4 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod4.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock4.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product4 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod5.get_value != "" && txt_new_ord_dialog_stock5.get_value.strip != ""
				product5 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod5.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock5.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product5 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod6.get_value != "" && txt_new_ord_dialog_stock6.get_value.strip != ""
				product6 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod6.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock6.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product6 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod7.get_value != "" && txt_new_ord_dialog_stock7.get_value.strip != ""
				product7 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod7.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock7.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product7 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod8.get_value != "" && txt_new_ord_dialog_stock8.get_value.strip != ""
				product8 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod8.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock8.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product8 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end
			if cmb_new_ord_dialog_prod9.get_value != "" && txt_new_ord_dialog_stock9.get_value.strip != ""
				product9 = {"prod_id" => prodRows[cmb_new_ord_dialog_prod9.get_current_selection]['prod_id'], "prod_amnt" => txt_new_ord_dialog_stock9.get_value.strip.to_i}
				newProduct = { orderProductsIndex => product9 }
				orderProducts = orderProducts.merge(newProduct)
				orderProductsIndex += 1
			end

			if orderProductsIndex != 0
				begin
					validation = Validation.new
					validation.guiCheckValidString(dp_new_ord_dialog_deliverydt.get_value.strftime("%Y-%m-%d"))
					Order.new.create(custRows[cmb_new_ord_dialog_custname.get_current_selection]['cust_id'].to_i, orderProducts, dp_new_ord_dialog_deliverydt.get_value.strftime("%Y-%m-%d"))
					@grd_prod.clear_grid
					btn_list_all_ord_click(nil)
				rescue => e
					Dialogs.new.showErrorDialog(e.class.to_s, e.message)
				end
			else
				Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_PROD)
			end
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_CUST)
			return
		end
	end
end

def btn_mod_ord_click (event)
	ordToMod = @grd_ord.get_selected_rows
	if ordToMod.length == 1
		ordID = @grd_ord.get_cell_value(ordToMod[0], 0)
		if (ordID != "")
			ordID = ordID.to_i
			begin
				order = Order.new
				if order.canBeEdited(ordID)
					product = Product.new
					ordDetList = order.listDetails(ordID)
					ordProdList = writeModOrdList(ordDetList)
					prodRows = product.listAll
					products = Array.new
					prodRows.each do |row|
						products.push(row['prod_name'])
					end
					mod_ord_dialog = Dialog.new(@panel_ord, -1, MOD_ORD_DIALOG, Point.new(5,5), Size.new(355, 420))
					#CheckListBox.new(Window parent,  Integer id, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE,Array choices = [], Integer style = 0, Validator validator = DEFAULT_VALIDATOR, String name = "listBox")
					chk_mod_ord_dialog_prodList = CheckListBox.new(mod_ord_dialog, -1, Point.new(5,5), Size.new(300,240), ordProdList)
					txt_mod_ord_dialog_mod_stock0 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[0]['prod_amount'].to_s, Point.new(305, 5), Size.new(35, 24))
					(txt_mod_ord_dialog_mod_stock1 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[1]['prod_amount'].to_s, Point.new(305, 29), Size.new(35, 24))) if ordProdList.length > 1
					(txt_mod_ord_dialog_mod_stock2 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[2]['prod_amount'].to_s, Point.new(305, 53), Size.new(35, 24))) if ordProdList.length > 2
					(txt_mod_ord_dialog_mod_stock3 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[3]['prod_amount'].to_s, Point.new(305, 77), Size.new(35, 24))) if ordProdList.length > 3
					(txt_mod_ord_dialog_mod_stock4 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[4]['prod_amount'].to_s, Point.new(305, 101), Size.new(35, 24))) if ordProdList.length > 4
					(txt_mod_ord_dialog_mod_stock5 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[5]['prod_amount'].to_s, Point.new(305, 125), Size.new(35, 24))) if ordProdList.length > 5
					(txt_mod_ord_dialog_mod_stock6 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[6]['prod_amount'].to_s, Point.new(305, 149), Size.new(35, 24))) if ordProdList.length > 6
					(txt_mod_ord_dialog_mod_stock7 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[7]['prod_amount'].to_s, Point.new(305, 173), Size.new(35, 24))) if ordProdList.length > 7
					(txt_mod_ord_dialog_mod_stock8 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[8]['prod_amount'].to_s, Point.new(305, 197), Size.new(35, 24))) if ordProdList.length > 8
					(txt_mod_ord_dialog_mod_stock9 = TextCtrl.new(mod_ord_dialog, -1, ordDetList[9]['prod_amount'].to_s, Point.new(305, 221), Size.new(35, 24))) if ordProdList.length > 9
					cmb_mod_ord_dialog_prod0 = ComboBox.new(mod_ord_dialog, -1, "", Point.new(5, 250), Size.new(300, 30), products)
					cmb_mod_ord_dialog_prod1 = ComboBox.new(mod_ord_dialog, -1, "", Point.new(5, 285), Size.new(300, 30), products)
					cmb_mod_ord_dialog_prod2 = ComboBox.new(mod_ord_dialog, -1, "", Point.new(5, 320), Size.new(300, 30), products)
					txt_mod_ord_dialog_add_stock0 = TextCtrl.new(mod_ord_dialog, -1, "", Point.new(305, 250), Size.new(35, 30))
					txt_mod_ord_dialog_add_stock1 = TextCtrl.new(mod_ord_dialog, -1, "", Point.new(305, 285), Size.new(35, 30))
					txt_mod_ord_dialog_add_stock2 = TextCtrl.new(mod_ord_dialog, -1, "", Point.new(305, 320), Size.new(35, 30))
					btn_mod_ord_dialog_ok = Button.new(mod_ord_dialog, -1, BTN_OK, Point.new(35, 355), Size.new(120, 30))
					btn_mod_ord_dialog_can = Button.new(mod_ord_dialog, -1, BTN_CANCEL, Point.new(190, 355), Size.new(120, 30))
					mod_ord_dialog.set_affirmative_id(btn_mod_ord_dialog_ok.get_id)
					mod_ord_dialog.set_escape_id(btn_mod_ord_dialog_can.get_id)

					if mod_ord_dialog.show_modal == btn_mod_ord_dialog_ok.get_id
						(order.modify(LBL_ADD, ordID, prodRows[cmb_mod_ord_dialog_prod0.get_current_selection]['prod_id'].to_i, txt_mod_ord_dialog_add_stock0.get_value.strip.to_i)) if (cmb_mod_ord_dialog_prod0.get_value != "" && txt_mod_ord_dialog_add_stock0.get_value.strip != "")
						(order.modify(LBL_ADD, ordID, prodRows[cmb_mod_ord_dialog_prod1.get_current_selection]['prod_id'].to_i, txt_mod_ord_dialog_add_stock1.get_value.strip.to_i)) if (cmb_mod_ord_dialog_prod1.get_value != "" && txt_mod_ord_dialog_add_stock1.get_value.strip != "")
						(order.modify(LBL_ADD, ordID, prodRows[cmb_mod_ord_dialog_prod2.get_current_selection]['prod_id'].to_i, txt_mod_ord_dialog_add_stock2.get_value.strip.to_i)) if (cmb_mod_ord_dialog_prod2.get_value != "" && txt_mod_ord_dialog_add_stock2.get_value.strip != "")
						order.modify(LBL_MOD_STK, ordID, prodRows[0]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock0.get_value.strip.to_i) if (txt_mod_ord_dialog_mod_stock0.is_modified && !txt_mod_ord_dialog_mod_stock0.is_empty && !chk_mod_ord_dialog_prodList.is_checked(0))
						order.modify(LBL_MOD_STK, ordID, prodRows[1]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock1.get_value.strip.to_i) if (ordProdList.length > 1 && txt_mod_ord_dialog_mod_stock1.is_modified && !txt_mod_ord_dialog_mod_stock1.is_empty && !chk_mod_ord_dialog_prodList.is_checked(1))
						order.modify(LBL_MOD_STK, ordID, prodRows[2]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock2.get_value.strip.to_i) if (ordProdList.length > 2 && txt_mod_ord_dialog_mod_stock2.is_modified && !txt_mod_ord_dialog_mod_stock2.is_empty && !chk_mod_ord_dialog_prodList.is_checked(2))
						order.modify(LBL_MOD_STK, ordID, prodRows[3]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock3.get_value.strip.to_i) if (ordProdList.length > 3 && txt_mod_ord_dialog_mod_stock3.is_modified && !txt_mod_ord_dialog_mod_stock3.is_empty && !chk_mod_ord_dialog_prodList.is_checked(3))
						order.modify(LBL_MOD_STK, ordID, prodRows[4]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock4.get_value.strip.to_i) if (ordProdList.length > 4 && txt_mod_ord_dialog_mod_stock4.is_modified && !txt_mod_ord_dialog_mod_stock4.is_empty && !chk_mod_ord_dialog_prodList.is_checked(4))
						order.modify(LBL_MOD_STK, ordID, prodRows[5]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock5.get_value.strip.to_i) if (ordProdList.length > 5 && txt_mod_ord_dialog_mod_stock5.is_modified && !txt_mod_ord_dialog_mod_stock5.is_empty && !chk_mod_ord_dialog_prodList.is_checked(5))
						order.modify(LBL_MOD_STK, ordID, prodRows[6]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock6.get_value.strip.to_i) if (ordProdList.length > 6 && txt_mod_ord_dialog_mod_stock6.is_modified && !txt_mod_ord_dialog_mod_stock6.is_empty && !chk_mod_ord_dialog_prodList.is_checked(6))
						order.modify(LBL_MOD_STK, ordID, prodRows[7]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock7.get_value.strip.to_i) if (ordProdList.length > 7 && txt_mod_ord_dialog_mod_stock7.is_modified && !txt_mod_ord_dialog_mod_stock7.is_empty && !chk_mod_ord_dialog_prodList.is_checked(7))
						order.modify(LBL_MOD_STK, ordID, prodRows[8]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock8.get_value.strip.to_i) if (ordProdList.length > 8 && txt_mod_ord_dialog_mod_stock8.is_modified && !txt_mod_ord_dialog_mod_stock8.is_empty && !chk_mod_ord_dialog_prodList.is_checked(8))
						order.modify(LBL_MOD_STK, ordID, prodRows[9]['prod_id'].to_i, txt_mod_ord_dialog_mod_stock9.get_value.strip.to_i) if (ordProdList.length > 9 && txt_mod_ord_dialog_mod_stock9.is_modified && !txt_mod_ord_dialog_mod_stock9.is_empty && !chk_mod_ord_dialog_prodList.is_checked(9))
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[0]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(0)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[1]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(1)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[2]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(2)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[3]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(3)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[4]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(4)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[5]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(5)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[6]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(6)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[7]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(7)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[8]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(8)
						order.modify(LBL_REMOVE, ordID, (product.searchByName(ordDetList[9]['prod_name']))[0]['prod_id'].to_i, nil) if chk_mod_ord_dialog_prodList.is_checked(9)
						btn_list_all_ord_click(nil)
						btn_list_det_ord_click(nil)
						btn_list_all_prod_click(nil)
					end
				end
			rescue => e
				Dialogs.new.showErrorDialog(e.class.to_s, e.message)
			end
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
			return
		end
	else
		if ordToMod.length == 0
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
			return
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_CNT_EDT_MLT_RW)
		end
	end
end

def writeModOrdList (rows)
	prodList = Array.new

	rows.each do |row|
		prodList.push(row['prod_name'])
	end
	
	return prodList
end

def btn_can_ord_click (event)
	updateOrderStatus(CANC_STATUS)
end

def btn_comp_ord_click (event)
	updateOrderStatus(COMP_STATUS)
end

def updateOrderStatus (action)
	ordToUpdate = @grd_ord.get_selected_rows
	if ordToUpdate.length > 0
		order = Order.new
		ordToUpdate.each do |rowNum|
			ordID = @grd_ord.get_cell_value(rowNum, 0)
			if (ordID != "")
				upd_ord_st_dialog = MessageDialog.new(nil,WRN_MOD_ORDST_CONF,MOD_ORDST_DIALOG,Wx::YES_NO | Wx::ICON_QUESTION)
				if upd_ord_st_dialog.show_modal == Wx::ID_YES
					begin
						case action
							when CANC_STATUS
								order.updateStatus(ordID.to_i, CANC_STATUS, nil)
							when COMP_STATUS
								order.updateStatus(ordID.to_i, COMP_STATUS, CURRENT_DATE)
						end
						btn_list_all_ord_click(nil)
					rescue => e
						Dialogs.new.showErrorDialog(e.class.to_s, e.message)	
					end
				end
			else
				Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
			end
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
	end
end

def writeOrdGrid (rows)
	@grd_ord.clear_grid
	@grd_ord_det.clear_grid
	rowNum = 0
	rows.each do |row|
		#set_cell_value(Integer row,  Integer col,  String s)
		@grd_ord.set_cell_value(rowNum, 0, "#{row['ord_id']}")
		@grd_ord.set_cell_value(rowNum, 1, "#{row['ord_status']}")
		@grd_ord.set_cell_value(rowNum, 2, "#{row['cust_name'] != nil ? row['cust_name'] : row['del_name']}")
		@grd_ord.set_cell_value(rowNum, 3, "#{row['income']}")
		@grd_ord.set_cell_value(rowNum, 4, "#{row['order_dt']}")
		@grd_ord.set_cell_value(rowNum, 5, "#{row['est_delivery_dt']}")
		@grd_ord.set_cell_value(rowNum, 6, "#{row['delivered_dt']}")
		#set_read_only(Integer row,  Integer col, Boolean isReadOnly = true)
		@grd_ord.set_read_only(rowNum, 0, true)
		@grd_ord.set_read_only(rowNum, 1, true)
		@grd_ord.set_read_only(rowNum, 2, true)
		@grd_ord.set_read_only(rowNum, 3, true)
		@grd_ord.set_read_only(rowNum, 4, true)
		@grd_ord.set_read_only(rowNum, 5, true)
		@grd_ord.set_read_only(rowNum, 6, true)
		#set_cell_alignment(Integer row,  Integer col,  Integer horiz, Integer vert)
		@grd_ord.set_cell_alignment(rowNum, 2, ALIGN_LEFT, ALIGN_CENTRE)
		rowNum += 1
	end
end

def btn_list_det_ord_click (event)
	ordToShowDetails = @grd_ord.get_selected_rows
	if ordToShowDetails.length == 1
		ordID = @grd_ord.get_cell_value(ordToShowDetails[0], 0)
		if (ordID != "")
			begin
				writeOrdDetGrid(Order.new.listDetails(ordID.to_i))
			rescue => e
				Dialogs.new.showErrorDialog(e.class.to_s, e.message)
			end
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
			return
		end
	else
		if ordToShowDetails.length == 0
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
			return
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_CNT_SHW_MLT_DET)
		end
	end
end

def writeOrdDetGrid (rows)
	@grd_ord_det.clear_grid
	rowNum = 0
	rows.each do |row|
		#set_cell_value(Integer row,  Integer col,  String s)
		@grd_ord_det.set_cell_value(rowNum, 0, "#{row['prod_name'] != nil ? row['prod_name'] : row['del_name']}")
		@grd_ord_det.set_cell_value(rowNum, 1, "#{row['prod_amount']}")
		@grd_ord_det.set_cell_value(rowNum, 2, "#{row['unit_price']}")
		#set_read_only(Integer row,  Integer col, Boolean isReadOnly = true)
		@grd_ord_det.set_read_only(rowNum, 0, true)
		@grd_ord_det.set_read_only(rowNum, 1, true)
		@grd_ord_det.set_read_only(rowNum, 2, true)
		#set_cell_alignment(Integer row,  Integer col,  Integer horiz, Integer vert)
		@grd_ord_det.set_cell_alignment(rowNum, 0, ALIGN_LEFT, ALIGN_CENTRE)
		rowNum += 1
	end
end

def btn_list_day_ord_click (event)
	showDateInputDialog(LBL_DAY)
end

def btn_list_month_ord_click (event)
	showDateInputDialog(LBL_MONTH)
end

def btn_list_year_ord_click (event)
	showDateInputDialog(LBL_YEAR)
end

def btn_list_range_ord_click (event)
	showDateInputDialog(LBL_RANGE)
end

def btn_list_date_ord_click (event)
	showDateInputDialog(LBL_DATE)
end

def showDateInputDialog (action)
	dt_inp_dialog = Dialog.new(@panel_ord, -1, INPUT_DATE_DIALOG, Point.new(5,5), (RUBY_PLATFORM.include?("linux") ? Size.new(300, 145) : Size.new(320, 175)))
	case action
		when LBL_RANGE
			StaticText.new(dt_inp_dialog, -1, LBL_DAY_STA, Point.new(15,12), Size.new(60, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_MONTH_STA, Point.new(15,47), Size.new(60, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_YEAR_STA, Point.new(15,82), Size.new(60, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_DAY_STP, Point.new(150,12), Size.new(65, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_MONTH_STP, Point.new(150,47), Size.new(65, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_YEAR_STP, Point.new(150,82), Size.new(65, 30))
			txt_dt_inp_dialog_day_sta = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(75, 5), Size.new(65, 30))
			txt_dt_inp_dialog_month_sta = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(75, 40), Size.new(65, 30))
			txt_dt_inp_dialog_year_sta = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(75, 75), Size.new(65, 30))
			txt_dt_inp_dialog_day_stp = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(220, 5), Size.new(65, 30))
			txt_dt_inp_dialog_month_stp = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(220, 40), Size.new(65, 30))
			txt_dt_inp_dialog_year_stp = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(220, 75), Size.new(65, 30))
		when LBL_DATE
			StaticText.new(dt_inp_dialog, -1, LBL_DAY, Point.new(15,12), Size.new(130, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_MONTH, Point.new(15,47), Size.new(130, 30))
			StaticText.new(dt_inp_dialog, -1, LBL_YEAR, Point.new(15,82), Size.new(140, 30))
			txt_dt_inp_dialog_day = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 5), Size.new(140, 30))
			txt_dt_inp_dialog_month = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 40), Size.new(140, 30))
			txt_dt_inp_dialog_year = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 75), Size.new(140, 30))
		when LBL_DAY
			StaticText.new(dt_inp_dialog, -1, LBL_DAY, Point.new(15,47), Size.new(130, 30))
			txt_dt_inp_dialog_day = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 40), Size.new(140, 30))
		when LBL_MONTH
			StaticText.new(dt_inp_dialog, -1, LBL_MONTH, Point.new(15,47), Size.new(130, 30))
			txt_dt_inp_dialog_month = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 40), Size.new(140, 30))
		when LBL_YEAR
			StaticText.new(dt_inp_dialog, -1, LBL_YEAR, Point.new(15,47), Size.new(140, 30))
			txt_dt_inp_dialog_year = TextCtrl.new(dt_inp_dialog, -1, "", Point.new(155, 40), Size.new(140, 30))
	end
	btn_dt_inp_dialog_ok = Button.new(dt_inp_dialog, -1, BTN_OK, Point.new(20, 110), Size.new(120, 30))
	btn_dt_inp_dialog_can = Button.new(dt_inp_dialog, -1, BTN_CANCEL, Point.new(160, 110), Size.new(120, 30))
	dt_inp_dialog.set_affirmative_id(btn_dt_inp_dialog_ok.get_id)
	dt_inp_dialog.set_escape_id(btn_dt_inp_dialog_can.get_id)
	if dt_inp_dialog.show_modal == btn_dt_inp_dialog_ok.get_id
		begin
			order = Order.new
			case action
				when LBL_RANGE
					rngSta = "#{txt_dt_inp_dialog_year_sta.get_value.strip}-#{txt_dt_inp_dialog_month_sta.get_value.strip}-#{txt_dt_inp_dialog_day_sta.get_value.strip}"
					rngStp = "#{txt_dt_inp_dialog_year_stp.get_value.strip}-#{txt_dt_inp_dialog_month_stp.get_value.strip}-#{txt_dt_inp_dialog_day_stp.get_value.strip}"
					writeOrdGrid(order.listByDate(action, rngSta, rngStp, nil, nil, nil))
				when LBL_DATE
					writeOrdGrid(order.listByDate(action, nil, nil, txt_dt_inp_dialog_day.get_value.strip, txt_dt_inp_dialog_month.get_value.strip, txt_dt_inp_dialog_year.get_value.strip))
				when LBL_DAY
					writeOrdGrid(order.listByDate(action, nil, nil, txt_dt_inp_dialog_day.get_value.strip, nil, nil))
				when LBL_MONTH
					writeOrdGrid(order.listByDate(action, nil, nil, nil, txt_dt_inp_dialog_month.get_value.strip, nil))
				when LBL_YEAR
					writeOrdGrid(order.listByDate(action, nil, nil, nil, nil, txt_dt_inp_dialog_year.get_value.strip))
			end
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	end
end

def btn_list_cust_ord_click (event)
	@txt_ord_find.set_value(@txt_ord_find.get_value.strip)
	if !@txt_ord_find.is_empty
		begin
			writeOrdGrid(Order.new.listByCust(@txt_ord_find.get_value))
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR,  ERR_GUI_NO_STR_INPUT)
		return
	end
end

def btn_list_prod_ord_click (event)
	@txt_ord_find.set_value(@txt_ord_find.get_value.strip)
	if !@txt_ord_find.is_empty
		begin
			writeOrdGrid(Order.new.listByProd(@txt_ord_find.get_value))
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
		end
	else
		Dialogs.new.showErrorDialog(LBL_ERROR,  ERR_GUI_NO_STR_INPUT)
		return
	end
end

def btn_gen_ord_bill_click (event)
	ordToGenBill = @grd_ord.get_selected_rows
	if ordToGenBill.length == 1
		ordID = @grd_ord.get_cell_value(ordToGenBill[0], 0)
		if (ordID != "")
			begin
				order = Order.new
				ordDet = order.listDetails(ordID.to_i)
				ord = order.retrieve(ordID.to_i)
				cust = Customer.new.retrieve(ord[0]['asoc_cust_id'])
				Billing.new.generateBill(cust, ord, ordDet)
				Dialogs.new.showInfoDialog(LBL_OK, "#{OK_BILL_GENERATED} #{ordID}")
			rescue => e
				Dialogs.new.showErrorDialog(e.class.to_s, e.message)
			end
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_EMPTY_ROW)
			return
		end
	else
		if ordToGenBill.length == 0
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_NO_ROW_SEL)
			return
		else
			Dialogs.new.showErrorDialog(LBL_ERROR, ERR_GUI_CNT_GEN_MLT_BILL)
		end
	end	
end
