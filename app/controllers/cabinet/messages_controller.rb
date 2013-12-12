class Cabinet::MessagesController < UserController
	include ActionView::Helpers::SanitizeHelper
	before_filter :require_login

	def index
		@messages = current_user.received_messages
		@active   = "inbox"
	end

	def inbox
		@messages = current_user.received_messages
	end

	def outbox
		@messages = current_user.sent_messages
		@active   = "outbox"
	end
	
	def show
		@active  = "new"
		@message = Message.find(params[:id])
		redirect_to :root unless @message.sender == current_user || @message.recepient == current_user
		Message.read_message(@message.id, current_user)
	end

	def new
		@recepient = User.find(params[:recepient_id])
		@apartment = House.find(params[:id])
		@message   = Message.new(:house_id=>@apartment.id)
		@active    = "new"
	end

	def delete
		sleep 1
		message = current_user.received_messages.find(params[:id])
		message.update_attribute(:recipient_deleted,true)
		render :json=>{:success=>true}
	end

	def delete_my
		sleep 1
		message = current_user.sent_messages.find(params[:id])
		message.update_attribute(:sender_deleted,true)
		render :json=>{:success=>true}
	end

	def create
		message = Message.new(params[:message])
		message.body = sanitize(message.body)	
		json = message.save	? {:success=>true,:url=>cabinet_messages_outbox_path} : {:success=>false,:msg=>"error"}
	ensure
		render :json=>json
	end


	
end