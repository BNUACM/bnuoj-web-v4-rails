module AccessHelper
  def no_priv
    raise Authorization::NotAuthorized
  end

  def not_logged_in
    raise Authorization::NotLoggedIn
  end

  # Get current user, if not signed in, return nil.
  def current_user
    return $_current_user unless $_current_user.nil?
    if !get_cookie("username").nil? && !get_cookie("password").nil?
      $_current_user ||= User.find_by(username: get_cookie("username"))
      if $_current_user.nil? || $_current_user.password != decrypt_password(get_cookie("password"))
        $_current_user = nil
        set_cookie("username", "")
        set_cookie("password", "")
      end
    else
      $_current_user = nil
    end
    $_current_user
  end

  def is_admin?
    if current_user.is_admin?
      yield if block_given?
      return true
    else
      return false
    end
  end

  # Whether current user has certain privilege
  def has_priv? (privilege, restriction = nil)
    if current_user.can? privilege,restriction
      yield if block_given?
      return true
    else
      return false
    end
  end

  # Require current user to have certain privilege
  def require_priv (privilege, restriction = nil)
    no_priv unless is_admin? || has_priv?(privilege,restriction)
  end

  def logged_in?
    current_user != nil
  end

  def require_login
    not_logged_in unless logged_in?
  end

  def is_contest_owner? contest
    if current_user.name == contest.owner
      yield if block_given?
      return true
    else
      return false
    end
  end

  def require_contest_owner contest
    no_priv unless is_contest_owner? contest
  end
end
