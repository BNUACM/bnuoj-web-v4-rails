class Privilege < ActiveRecord::Base

    belongs_to :user, inverse_of: :privileges
    belongs_to :user_group, inverse_of: :privileges
end
