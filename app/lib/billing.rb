class Billing

	attr_accessor

	def initialize

	end
	
	def checkValidStatus (ordID)
		begin
			Validation.new.checkValidInt(ordID)
			ordStatus = $db.execute("select ord_status from orders where ord_id = #{ordID}")[0]['ord_status']
			raise RuntimeError, "#{ERR_CANT_BILL_ORD} #{ordID}", ERR_LOC_BILL_VLDST if (ordStatus != PEND_STATUS && ordStatus != COMP_STATUS)
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
	
	def generateBill (customer, order, orderDetails)
		begin
			checkValidStatus(order[0]['ord_id'])
			billName = "#{LBL_BILL} - #{CLI_NAME} - #{LBL_BILL_ORDID} #{order[0]['ord_id']}"
			Prawn::Document.generate("#{BILL_PATH}#{billName}.pdf") do
				def row (cant, desc, unitPr, subTotal,tblWidths)
					rows = [[]]

					rows[0][0] = cant
					rows[0][1] = desc
					rows[0][2] = unitPr
					rows[0][3] = subTotal

					make_table(rows) do |t|
						t.column_widths = tblWidths
						t.cells.style :borders => [:left, :right], :padding => 2
						t.columns(0).align = :center
						t.columns(2..3).align = :right
					end
				end

				def create_bounding_box (pdf)
					box = pdf.bounds
					width = box.width #540
					height = box.height #720
					left_top_corner = [0,height] 
					right_top_corner = [width,height]
					pdf.bounding_box([0,600], :width=>width, :height=>115) { pdf.stroke_bounds }
				end		

				font_size = 10

				(image "./img/#{CLI_LOGO}", :at => [0,720], :scale => 0.5) if CLI_LOGO != ""
				text " "
				text("#{LBL_DATE}: #{Time.now.strftime("%d-%m-%Y")}", :indent_paragraphs => 200, :align => :right)
				text " "
				text("#{LBL_BILL_CLIENT}: #{CLI_NAME}", :indent_paragraphs => 200, :align => :justify, :size => 24, :style => :bold)
				text("#{LBL_ADDRESS}: #{CLI_ADD}", :indent_paragraphs => 200, :align => :justify)
				text("#{LBL_PHONE}: #{CLI_PHO}", :indent_paragraphs => 200, :align => :justify)
				text("#{LBL_CUIT}: #{CLI_CUIT}", :indent_paragraphs => 200, :align => :justify)
				text " "
				text("#{LBL_BILL_CUSTDET}", :indent_paragraphs => 15, :align => :justify, :style => :bold)
				text("#{LBL_NAME}: #{customer[0]['cust_name']}", :indent_paragraphs => 60, :align => :justify)
				text("#{LBL_ADDRESS}: #{customer[0]['cust_address']}", :indent_paragraphs => 60, :align => :justify)
				text("#{LBL_PHONE}: #{customer[0]['cust_phone']}", :indent_paragraphs => 60, :align => :justify)
				text " "
				text("#{LBL_BILL_ORDDET}", :indent_paragraphs => 15, :align => :justify, :style => :bold)
				text("#{LBL_ID}: #{order[0]['ord_id']}", :indent_paragraphs => 60, :align => :justify)
				ordDate = order[0]['order_dt'].split("-")
				text("#{LBL_ORDERDT}: #{ordDate[2]}-#{ordDate[1]}-#{ordDate[0]}", :indent_paragraphs => 60, :align => :justify)
				create_bounding_box(self)

				text " "

				tblWidths = [90, 250, 100, 100]
				tblHeaders = ["#{LBL_AMOUNT}", "#{LBL_PRODNAME}", "#{LBL_UNITPRC}", "#{LBL_BILL_SUBTOTAL}"]

				head = make_table([tblHeaders], :column_widths => tblWidths)

				data = []

				subTotal = 0
				orderDetails.each do |product|
					amnt = product['prod_amount']
					desc = product['prod_name']
					prc = product['unit_price']
					subTotal += (amnt * prc)
					data << row(amnt,desc,prc,subTotal,tblWidths)
				end

				if orderDetails.length < 22
					(22-orderDetails.length).times do
						data << row(" "," "," "," ",tblWidths)
					end
				end

				table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[f3f3f3 ffffff]) do
					row(0).style :background_color => '000000', :text_color => 'ffffff'
					cells.style :borders => []
				end

				tblWidths = [440, 100]
				tblHeaders = ["#{LBL_BILL_TOTAL}", "#{subTotal}"]
				data = []

				head = make_table([tblHeaders], :column_widths => tblWidths)
				table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[000000 ffffff]) do
					row(0).style :background_color => '000000', :text_color => 'ffffff'
					cells.style :borders => []
				end
				text("\n#{TXT_BILL_ABOUT}", :indent_paragraphs => 0, :align => :right, :style => :italic, :size => 8)
				text("#{TXT_BILL_CONTACT}", :indent_paragraphs => 0, :align => :right, :style => :italic, :size => 8)
			end
		rescue => e
			writeLog(LBL_ERROR, e.class.to_s, e.message, e.backtrace.to_s)
			raise
		end
	end
end
