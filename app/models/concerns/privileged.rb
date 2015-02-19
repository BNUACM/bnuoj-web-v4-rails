module Privileged
  extend ActiveSupport::Concern

  included do
    has_many :privileges
  end

  def parse_priv
    @my_priv = {}
    privileges.each do |priv|
      @my_priv[priv.privilege] = {} if @my_priv[priv.privilege].nil?
      @my_priv[priv.privilege][priv.restrict_to_key] = [] if @my_priv[priv.privilege][priv.restrict_to_key].nil?
      @my_priv[priv.privilege][priv.restrict_to_key] << priv.restrict_to_value
    end
    return @my_priv
  end

  def grant_priv(privilege, restriction)
    if @my_priv[privilege].nil?
      @my_priv[privilege] = restriction
    else
      @my_priv[privilege] = @my_priv[privilege].merge restriction
    end
  end

  # Whether has certain privilege or not
  def can(privilege, target = nil)
    if @my_priv && @my_priv[privilege]
      return true if @my_priv[privilege]["any"]
      @my_priv[privilege].each do |attr,allowed|
        if target.is_a? Hash
          return true if allowed.include? target[attr]
        elsif target.is_a? Object
          return true if allowed.include? target.send(attr)
        else
          raise ArgumentError
        end
      end if target
    end
    return false
  end

end
