class Admin::SettingsController < AdminController
	before_filter :require_login
	def index
		@settings = {}
		AdminSettings.all.each{|st| @settings[:"#{st.setting}"] = st.value }
	end

	def save
		AdminSettings.all.each{ |st| st.update_attribute(:value,params[:"#{st.setting}"]) if params.has_key? st.setting}
		redirect_to "/admin/settings"
	end

end