module UsersHelper
  def before_login_prompt
    if params[:referer]
      "<p class=\"alert alert-info\">#{t "global.prompts.need_login"}</p>".html_safe 
    end
  end
end
