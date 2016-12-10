module DeviseHelper
	def devise_error_messages!
		return '' if @user.errors.empty?

		messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg)}.join
		html = <<-HTML
		<div class="alert alert-error alert-danger"> <button type="button" class="close" data-dismiss="alert">x</button>
		  #{messages}
		  </div>
		  HTML

		  html.html_safe
		end
	end