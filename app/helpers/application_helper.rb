module ApplicationHelper
  def has_priv(privilege, target = nil)
    if $current_user.can privilege,target
      yield if block_given?
      return true
    else
      return false
    end
  end
end
