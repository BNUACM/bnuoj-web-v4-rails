module UsersHelper
  def before_login_prompt
    "<p class=\"alert alert-info\">#{t "global.need_login"}</p>".html_safe if params[:referer]
  end
end
