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
end
