# encoding: UTF-8
if AdminModule.count == 0
	AdminModule.create(name:"Користувачі",action:"users",parent_id:0,:ico_cls=>"icon-group")
	AdminModule.create(name:"Штрафи",action:"penalties",parent_id:0,:ico_cls=>"sidebar-calendar")
	# AdminModule.create(name:"Транзакції",action:"transactions",parent_id:0,:ico_cls=>"sidebar-charts")
	AdminModule.create(name:"Шаблони Email",action:"emails",parent_id:0,:ico_cls=>"sidebar-forms")
	AdminModule.create(name:"Налаштування",action:"settings",parent_id:0,:ico_cls=>"sidebar-gear")
	# AdminModule.create(name:"Довідник",action:"articles",parent_id:0,:ico_cls=>"sidebar-widgets")
	AdminModule.create(name:"Зручності",action:"facilities",parent_id:0,:ico_cls=>"sidebar-widgets")
	AdminModule.create(name:"Апартаменти",action:"apartaments",parent_id:0,:ico_cls=>"sidebar-widgets")
end

if City.count == 0
	City.create(name_ru:"Никосия")
	City.create(name_ru:"Корнос")
end

if Facility.count == 0
	Facility.create(name_ru:"Удобность 1", name_uk:"Удобность 1", name_en:"Удобность 1", seo:"udobnost1")
	Facility.create(name_ru:"Удобность 2", name_uk:"Удобность 2", name_en:"Удобность 2", seo:"udobnost2")
end

if Characteristic.count == 0
	Characteristic.create(name_ru:"parametr 1", name_uk:"parametr 1", name_en:"parametr 1")
	Characteristic.create(name_ru:"parametr 2", name_uk:"parametr 2", name_en:"parametr 2")
end

if User.count == 0
	user = User.create(:first_name=>"Админ",:last_name=>"Админ",:patronic=>"Админыч",username:"admin",email:"admin@admin.net",password:"admin",:city=>"Admin",:street=>"Admin",:building=>"Admin")
	admin_role = Role.create(role_type:"admin",name:"Administrator")
	Role.create(role_type:"login",name:"Default User")
	user.roles << admin_role
	user.save
	admin_role.admin_modules << AdminModule.all
	admin_role.save
end

if EmailTemplate.count == 0
	EmailTemplate.create(:email_type=>:password_change,:html=>"",:name=>"Зміна пароля")
	EmailTemplate.create(:email_type=>:registration,:html=>"",:name=>"Реєстрація")
	EmailTemplate.create(:email_type=>:create_penalty,:html=>"",:name=>"Створення платіжки")
	EmailTemplate.create(:email_type=>:pay_penalty,:html=>"",:name=>"Оплата платіжки")
end

if AdminSettings.count == 0
	AdminSettings.create(:setting=>:lang,:value=>:ru)
	AdminSettings.create(:setting=>:price,:value=>10)
	AdminSettings.create(:setting=>:shop_api_key,:value=>"weff4546wefw46")
	AdminSettings.create(:setting=>:shop_secret_key,:value=>"56w4ef46we4f6we4")
	AdminSettings.create(:setting=>:shop_link,:value=>"wef")
	AdminSettings.create(:setting=>:oferta_ru,:value=>"wef")
	AdminSettings.create(:setting=>:oferta_ua,:value=>"wef")
end