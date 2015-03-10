class SessionsController < ApplicationController

  # POST /session
  def create
    if User.where(username: login_params[:username],
                  password: hash_password(login_params[:password])).count > 0
      @session = Session.new token: SecureRandom.hex,
                             username: login_params[:username],
                             ipaddr: request.remote_ip,
                             expire_at: Time.now + 2.weeks
      @session.save
      set_cookie "token", @session.token, params[:cksave].nil? ? 0 : 2.weeks
      respond_to do |format|
        format.html { redirect_to params[:referer] } if params[:referer]
        format.html { redirect_to controller: "home", action: "index" }
        format.json { render json: { msg: t("user.prompts.logged_in") } }
      end
    elsif
      render json: { msg: t("user.prompts.userpass_error") },
             status: :not_acceptable
    end
  end

  # DELETE /session
  def destroy
    begin
      @session = Session.destroy get_cookie "token"
    rescue ActiveRecord::RecordNotFound
      logger.info "Invalid session token #{get_cookie "token"}"
    end
    set_cookie "token", nil
    redirect_to :back
  end

  private
    def login_params
      params.require(:session).permit([:username, :password])
    end

end
