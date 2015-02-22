class Privilege < ActiveRecord::Base
    belongs_to :user, inverse_of: :privileges
end
