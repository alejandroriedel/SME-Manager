def load_about_panel
	panel = Panel.new(self)
	StaticText.new(panel, -1, TXT_ABOUT_HEADER, Point.new(75,50), Size.new(900, 200))
	StaticText.new(panel, -1, TXT_ABOUT_APPINFO, Point.new(75,250), Size.new(900, 50))
	StaticText.new(panel, -1, LBL_ABOUT_EMAIL, Point.new(75,303), Size.new(75, 20))
	StaticText.new(panel, -1, LBL_ABOUT_BLOG, Point.new(75,323), Size.new(75, 20))
	StaticText.new(panel, -1, LBL_ABOUT_GITHUB, Point.new(75,343), Size.new(75, 20))
	StaticText.new(panel, -1, LBL_ABOUT_LINKED, Point.new(75,363), Size.new(75, 20))
	HyperlinkCtrl.new(panel,  -1,  "alejandro.riedel@gmail.com", "mailto:alejandro.riedel@gmail.com", Point.new(155,300), Size.new(350, 20))
	HyperlinkCtrl.new(panel,  -1,  "alejandroriedel.blogspot.com", "http://alejandroriedel.blogspot.com", Point.new(155,320), Size.new(350, 20))
	HyperlinkCtrl.new(panel,  -1,  "github.com/alejandroriedel", "https://github.com/alejandroriedel", Point.new(155,340), Size.new(350, 20))
	HyperlinkCtrl.new(panel,  -1,  "ar.linkedin.com/pub/alejandro-riedel/13/5a7/356", "http://ar.linkedin.com/pub/alejandro-riedel/13/5a7/356", Point.new(155,360), Size.new(350, 20))
	return panel
end
