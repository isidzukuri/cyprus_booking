class PaymentManager

	def surchage
		return 0.00
	end

	def commision
		return 0.00
	end

	def invoice_price
		AdminSettings.find_by_setting(:price).value.to_f
	end

	def create_paymnet penalty 
		trans  = Transaction.create(
			:penalty_id => penalty.id , 
			:user_id    => penalty.user.id,
			:amount     => penalty.total_cost,
			:commision  => commision
			)
	end

	def process_payment penalty
		@penalty = penalty
		create_request
		#pay_request 4545
	end



	private

	def create_request
		url = Settings.payment.ip.to_uri
        res =
        url.post_form(:AS_reqinfo	=> _create_request_header("ECPAYM_CREATE"), 
        			  :AS_reqdata	=> _create_request_footer("ECPAYM_CREATE") , 
       			  	  :XMLdata		=> _create_payment_request_body
        			 )
        p res
        parse_result res
	end

	def pay_request payment_id
		url = Settings.payment.ip.to_uri
        res =
        url.post_form(:AS_reqinfo	=> _create_request_header("ECPAYM_PAY"), 
        			  :AS_reqdata	=> _create_request_footer("ECPAYM_PAY") , 
       			  	  :XMLdata		=> _create_pay_request_body(payment_id)
        			 )
        parse_result res
	end

	def _create_request_header type
		refresh
		result = 
		@xml.reqinfo do
			@xml.Action(type)
			@xml.AS_System_ID(1)
			@xml.AS_Client_ID(@penalty.transaction.id)
			@xml.AS_Client_Code("IFT")
		end
	end
	def _create_request_footer type
		refresh
		result = 
		@xml.reqdata do
			@xml.Action(type)
			@xml.Answer_as_ref("F")
			@xml.ActionParams do 
				@xml.ActionParam(:name=>"P_MFO",:type=>"STR"){@xml.text! "300131"}
				@xml.ActionParam(:name=>"P_XML",:type=>"CLOB",:refvalue=>"xml3")
			end
		end
	end

	def _create_payment_request_body
		refresh
		result = 
		@xml.reqdata do
			@xml.SYSTEM do 
				@xml.PAYMENT_SYSTEM("ECP_GAI")
				@xml.ACTION("ECPAYM_CREATE")
				@xml.MERCHANDLID("001030000000119")
				@xml.TERMINALID("ECP_WEB01")
				@xml.GROUPID(1)
				@xml.OPERATIONID(123)
				@xml.DATEOPERATION(Time.now.strftime("%d.%m.%Y %H.%I.%S"))
				@xml.TRANSACTIONID(@penalty.transaction.id)
				@xml.DATETRANSACTION(Time.now.strftime("%d.%m.%Y %H.%I.%S"))
				@xml.PAYMENTID
				@xml.SHIFTNO(1)
				@xml.BATCHNO(1)
			end
			@xml.PAYMENT_DATA do
				@xml.CONTRACTNUMBER("---------------------------")
				@xml.PARAM1(:name=>"CLOSE_DATE")     {@xml.text! "---------------------------"}
				@xml.PARAM2(:name=>"CURRENCY")		 {@xml.text! "980"}
				@xml.PARAM3(:name=>"TRXTYP")		 {@xml.text! "1"}
				@xml.PARAM4(:name=>"OPERATIONTID")	 {@xml.text! "123"}
				@xml.PARAM5(:name=>"SETTLEMENT_DATE"){@xml.text! Time.now.strftime("%d.%m.%Y %H.%I.%S")}
				@xml.PARAM6(:name=>"INVOICE_AMOUNT") {@xml.text! @penalty.protocol_penalty.to_s}
				@xml.PARAM7(:name=>"AMOUNT")		 {@xml.text! @penalty.protocol_penalty.to_s}
				@xml.PARAM8(:name=>"AMOUNT_COM")	 {@xml.text! commision.to_s}
				@xml.PARAM9(:name=>"PAYMENT_CODE")	 {@xml.text! @penalty.payment_detail.budget_code.to_s}
				@xml.PARAM10(:name=>"SERIES_PROT")	 {@xml.text! @penalty.protocol_serial.to_s}
				@xml.PARAM11(:name=>"NUMBER_PROT")	 {@xml.text! @penalty.protocol_number.to_s}
				@xml.PARAM12(:name=>"NAME")			 {@xml.text! @penalty.user.fio}
				@xml.PARAM13(:name=>"ACCOUNT_CT")	 {@xml.text! @penalty.payment_detail.payment_number.to_s}
				@xml.PARAM14(:name=>"EXT_NAME")		 {@xml.text! @penalty.payment_detail.bank.name}
				@xml.PARAM15(:name=>"EXT_OKPO")		 {@xml.text! @penalty.payment_detail.edrpo.to_s}
				@xml.PARAM16(:name=>"MFO_CT")		 {@xml.text! @penalty.payment_detail.bank.bank_code.to_s}

				@xml.PARAM17(:name=>"REG_POST_INDEX"){@xml.text! ""}
				@xml.PARAM18(:name=>"REG_CODE")		 {@xml.text! ""}
				@xml.PARAM19(:name=>"COUNTY")		 {@xml.text! ""}
				@xml.PARAM20(:name=>"CITY")		     {@xml.text! @penalty.user.city}
				@xml.PARAM21(:name=>"ADDRESS")       {@xml.text! @penalty.user.address}
			end
		end
	end

	def _create_pay_request_body payment_id
		refresh
		result = 
		@xml.reqdata do
			@xml.SYSTEM do 
				@xml.PAYMENT_SYSTEM("ECP_GAI")
				@xml.ACTION("ECPAYM_PAY")
				@xml.MERCHANDLID("001030000000119")
				@xml.TERMINALID("ECP_WEB01")
				@xml.GROUPID(1)
				@xml.OPERATIONID(123)
				@xml.DATEOPERATION(Time.now.strftime("%d.%m.%Y %H.%I.%S"))
				@xml.TRANSACTIONID(@penalty.transaction.id)
				@xml.DATETRANSACTION(Time.now.strftime("%d.%m.%Y %H.%I.%S"))
				@xml.PAYMENTID(payment_id)
				@xml.SHIFTNO(1)
				@xml.BATCHNO(1)
			end
			@xml.PAYMENT_DATA do
				@xml.AMOUNT(@penalty.protocol_penalty)
				@xml.BOCMMISSION(commision)
				@xml.TOTALAMOUNT((commision + @penalty.protocol_penalty))
			end
		end
	end




	def parse_result data
		data
	end

    def refresh
    	@xml = Builder::XmlMarkup.new
    end
end