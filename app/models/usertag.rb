class Usertag < ActiveRecord::Base
    self.table_name = "usertag"
    self.primary_key = "id"

    belongs_to :user, primary_key: "username", foreign_key: "username", inverse_of: :tags
end
