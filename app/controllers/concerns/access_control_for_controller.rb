module AccessControlForController
  extend ActiveSupport::Concern

  included do
    rescue_from Authorization::NotAuthorized, :with => :access_denied
  end

  def require_priv(privilege, target = nil)
    raise Authorization::NotAuthorized unless $current_user.can privilege,target
  end

  def has_priv(privilege, target = nil)
    if $current_user.can privilege,target
      yield if block_given?
      return true
    else
      return false
    end
  end

  def access_denied
    respond_to do |format|
      format.html { render "application/access_denied" }
      format.json { render :status => :forbidden, json: { msg: t("global.need_admin") } }
    end
  end

end
