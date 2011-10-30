class GUIApp < App
	def on_init
		begin
			MainFrame.new
		rescue => e
			Dialogs.new.showErrorDialog(e.class.to_s, e.message)
			raise
		end
	end
end
