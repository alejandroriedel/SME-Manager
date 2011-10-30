class MainFrame < Frame
	def initialize
		super(nil, -1, "#{APP_NAME} #{APP_VERSION}: #{CLI_NAME}", DEFAULT_POSITION, (RUBY_PLATFORM.include?("linux") ? Size.new(1135,500) : Size.new(1024,555)))
		@panel_cust = load_cust_panel
		@panel_prod = load_prod_panel
		@panel_ord = load_ord_panel
		@panel_about = load_about_panel
		if RUBY_PLATFORM.include?("linux")
			@listbook = Listbook.new(self, -1, DEFAULT_POSITION, Size.new(1125, 495))
			@listbook.add_page(@panel_cust, LBL_CUST)
			@listbook.add_page(@panel_prod, LBL_PROD)
			@listbook.add_page(@panel_ord, LBL_ORD)
			@listbook.add_page(@panel_about, LBL_ABOUT)			
		else
			#Notebook.new(Window parent,  Integer id, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE,  Integer style = 0, String name = NotebookNameStr)
			@notebook = Notebook.new(self, -1, DEFAULT_POSITION, Size.new(1024, 520))
			#Boolean add_page(Window page,  String text, Boolean select = false, Integer imageId = -1)
			@notebook.add_page(@panel_cust, LBL_CUST)
			@notebook.add_page(@panel_prod, LBL_PROD)
			@notebook.add_page(@panel_ord, LBL_ORD)
			@notebook.add_page(@panel_about, LBL_ABOUT)
		end
		show
	end
end
