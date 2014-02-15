class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
    Base64.encode64(Encryptor.encrypt(:value => password, :key => OJ_CONFIG["encrypt"]["password"]["key"], :iv => OJ_CONFIG["encrypt"]["password"]["iv"], :salt => OJ_CONFIG["encrypt"]["password"]["salt"]))
  end

  def decrypt_password(password)
    Encryptor.decrypt(:value => Base64.decode64(password), :key => OJ_CONFIG["encrypt"]["password"]["key"], :iv => OJ_CONFIG["encrypt"]["password"]["iv"], :salt => OJ_CONFIG["encrypt"]["password"]["salt"])
  end

  def logged_in?
    !current_user.nil?
  end
  helper_method :logged_in?

  def current_user
    if !get_cookie("username").nil? && !get_cookie("password").nil?
      @user ||= User.find_by(username: get_cookie("username"))
      if @user.nil? || @user.password != decrypt_password(get_cookie("password"))
        @user = nil
        set_cookie("username", "")
        set_cookie("password", "")
      end
    else
      @user = nil
    end
    @user
  end
  helper_method :current_user
end
