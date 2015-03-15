class UsersController < ApplicationController
  rescue_from UserError::UserNotFound do
    @error_msg = t "user.prompts.nonexist"
    respond_to do |format|
      format.html { render "home/error", layout: !request.xhr? }
      format.json { render json: { msg: @error_msg }, status: :bad_request }
    end
  end

  def login
    password = hash_password(params[:password])
    user = User.find_by(username: params[:username])
    if user.nil? || user.password != password
      render(
          json: { msg: t("user.prompts.userpass_error") },
          status: :not_acceptable)
      return
    end
    cookie_time = 0
    if !params[:cksave].nil?
      cookie_time = 3.years
    end
    set_cookie("username", user.username, cookie_time)
    set_cookie("password", encrypt_password(user.password), cookie_time)
    respond_to do |format|
      format.html { redirect_to params[:referer] } if params[:referer]
      format.html { redirect_to controller: "home", action: "index" }
      format.json { render json: { msg: t("user.prompts.logged_in") } }
    end
  end

  def signin
    respond_to do |format|
      format.html
    end
  end

  def logout
    set_cookie("username", "")
    set_cookie("password", "")
    redirect_to :back
  end

  # GET /users
  # GET /users.json
  def index
    # @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by(username: params[:id])
    raise UserError::UserNotFound if @user.nil?
    options = {}
    options[:except] = []
    if !logged_in? || !current_user.is_admin?
      options[:except] |= [:ipaddr]
    end
    respond_to do |format|
      format.html
      format.json { render json: @user.to_json(options) }
    end
  end

  # GET /users/compare/username1/username2
  def compare
    @user1 = User.find_by(username: params[:user1])
    @user2 = User.find_by(username: params[:user2])
    raise UserError::UserNotFound if @user1.nil? || @user2.nil?
    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render json: { 
          @user1.username => {
            'ac' => @user1.accepted_pids,
            'wa' => @user1.failed_pids
          },
          @user2.username => {
            'ac' => @user2.accepted_pids,
            'wa' => @user2.failed_pids
          }
      }}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def user_params
  end
end
