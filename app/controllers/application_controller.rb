class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Authorization::NotAuthorized, :with => :access_denied
  rescue_from Authorization::NotLoggedIn, :with => :need_login

  def set_cookie(name, value, expires_in = 0, path = root_path)
    if expires_in > 0
      cookie = {
        :value => value.to_s,
        :path => path,
        :expires => Time.now + expires_in
      }
    else
      cookie = {
        :value => value.to_s,
        :path => path
      }
    end
    cookies[OJ_CONFIG["misc"]["cookie_prefix"] + name.to_s] = cookie
  end

  def get_cookie(name)
    cookies[OJ_CONFIG["misc"]["cookie_prefix"] + name]
  end

  def hash_password(password)
    Digest::SHA1.hexdigest(Digest::MD5.hexdigest(password))
  end

  def encrypt_password(password)
    Base64.encode64(Encryptor.encrypt(
        :value => password,
        :key => OJ_CONFIG["encrypt"]["password"]["key"],
        :iv => OJ_CONFIG["encrypt"]["password"]["iv"],
        :salt => OJ_CONFIG["encrypt"]["password"]["salt"]))
  end

  def decrypt_password(password)
    Encryptor.decrypt(
        :value => Base64.decode64(password),
        :key => OJ_CONFIG["encrypt"]["password"]["key"],
        :iv => OJ_CONFIG["encrypt"]["password"]["iv"],
        :salt => OJ_CONFIG["encrypt"]["password"]["salt"])
  end

  # Get current user, if not signed in, return nil.
  def current_user
    return nil if get_cookie("token").nil?
    begin
      @session = Session.find(get_cookie("token"))
      if @session.ipaddr == request.remote_ip
        if @session.expire_at < Time.now
          @session.destroy and set_cookie "token", nil
        else
          @current_user ||= @session.user
          if @session.cksave
            @session.expire_at = Time.now + 2.weeks and @session.save
            set_cookie "token", @session.token, 2.weeks
          end
        end
      else
        set_cookie "token", nil
      end
    rescue ActiveRecord::RecordNotFound
      logger.info "Invalid session token #{get_cookie "token"}"
    end
    return @current_user
  end
  helper_method :current_user

  def logged_in?
    current_user != nil
  end
  helper_method :logged_in?

  # When logged in is needed
  def need_login
    respond_to do |format|
      format.html {
        redirect_to(
            controller: "users",
            action: "signin",
            referer: request.original_url)
      }
      format.json {
        render(
            status: :forbidden,
            json: { msg: t("global.prompts.need_login") }
        )
      }
    end
  end

  # When access denied
  def access_denied
    respond_to do |format|
      format.html { render "application/access_denied" }
      format.json {
        render(
            status: :forbidden,
            json: { msg: t("global.prompts.access_denied") }
        )
      }
    end
  end
end
