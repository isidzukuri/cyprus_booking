module ApplicationHelper
  def exchange total,currency
    (Exchange.convert(currency, $currency) * total).round(2)
  end
  def book_steps(steps, current = 0)
  	content_tag :div, :class => 'steps' do
	    content_tag :ul  do
	      steps.each_with_index.map do |txt, i|
	        content_tag :li , :class=>("last" if i == steps.size - 1 ) do
	        	content_tag(:span,(i+1),:class=>[("past" if current > i),("active" if current == i),"number"].compact  ) + content_tag(:span,txt,:class=>[("past" if current > i),("active" if current == i),"steps_lable"].compact )
	        end
	      end.join("").html_safe
	    end
	end
  end
  def car_class_convert code
    clas_regular = {
      "special"  => "((X...)|(.V..)).*",
      "mini"     => "[EM][^V].*",
      "economy"  => "[E][^V].*",
      "compact"  => "[C][^V].*",
      "midsize"  => "[I][^V].*",
      "intmedia" => "[I][^V].*",
      "standart" => "[S][^V].*",
      "full"     => "[F][^V].*",
      "premium"  => "[P][^V].*",
      "lux"      => "[L][^V].*"  
    }
    car_class = "standart"
    clas_regular.each_pair do |n,r|
      name = code.match(/#{r}/)
      car_class = n unless name.nil?
    end
    car_class
  end

  def check_image path,missing
    return missing if path.nil?
    status = Net::HTTP.get_response(URI(path)).code.to_i
    [404].include?(status) ? missing : path
  end
  
end
