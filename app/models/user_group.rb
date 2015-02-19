class UserGroup < ActiveRecord::Base
  include Privileged

  has_and_belongs_to_many :users, inverse_of: :user_groups

end
