module AccessControlForModel

  def require_priv(privilege)
    raise Authorization::NotAuthorized unless $current_user.can privilege,self
  end

end
