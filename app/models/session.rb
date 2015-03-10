class Session < ActiveRecord::Base
  self.primary_key = "token"

  belongs_to :user, primary_key: "username", foreign_key: "username",
      inverse_of: :sessions

end
