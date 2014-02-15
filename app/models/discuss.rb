class Discuss < ActiveRecord::Base
    self.table_name = "discuss"
    self.primary_key = "id"

    belongs_to :user, primary_key: "uname", foreign_key: "username", inverse_of: :discusses
    belongs_to :topic, primary_key: "rid", foreign_key: "rid", inverse_of: :discusses
end
