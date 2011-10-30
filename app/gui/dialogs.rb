class Dialogs
	def initialize

	end

	def showErrorDialog (title, message)
		#Dialog.new(Window parent, Integer id, String title, Point pos = DEFAULT_POSITION, Size size = DEFAULT_SIZE, Integer style = DEFAULT_DIALOG_STYLE, String name = "dialogBox")
		md = MessageDialog.new(nil, message, title, ICON_ERROR)
		if RUBY_PLATFORM.include?("linux")
			if md.show_modal == Wx::ID_OK
				md.destroy()
			end
		else
			md.show_modal
		end
	end
	
	def showInfoDialog (title, message)
		md = MessageDialog.new(nil,message,title,Wx::ICON_INFORMATION)
		if RUBY_PLATFORM.include?("linux")
			if md.show_modal == Wx::ID_OK
				md.destroy()
			end
		else
			md.show_modal
		end
	end	
end
