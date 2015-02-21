class ApplicationController < ActionController::Base
  include AccessHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Authorization::NotAuthorized, :with => :access_denied
  rescue_from Authorization::NotLoggedIn, :with => :need_login

  def set_cookie(name, value, expires_in = 0, path = root_path)
    if expires_in > 0
      cookie = {:value => value.to_s, :path => path, :expires => Time.now + expires_in}
    else
      cookie = {:value => value.to_s, :path => path}
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
    Base64.encode64(Encryptor.encrypt(:value => password, :key => OJ_CONFIG["encrypt"]["password"]["key"],
      :iv => OJ_CONFIG["encrypt"]["password"]["iv"], :salt => OJ_CONFIG["encrypt"]["password"]["salt"]))
  end

  def decrypt_password(password)
    Encryptor.decrypt(:value => Base64.decode64(password), :key => OJ_CONFIG["encrypt"]["password"]["key"],
      :iv => OJ_CONFIG["encrypt"]["password"]["iv"], :salt => OJ_CONFIG["encrypt"]["password"]["salt"])
  end

  # When logged in is needed
  def need_login
    respond_to do |format|
      format.html { redirect_to controller: "users", action: "login" }
      format.json { render status: :forbidden, json: { msg: t("global.need_login") } }
    end
  end

  # When access denied
  def access_denied
    respond_to do |format|
      format.html { render "application/access_denied" }
      format.json { render status: :forbidden, json: { msg: t("global.access_denied") } }
    end
  end
end
