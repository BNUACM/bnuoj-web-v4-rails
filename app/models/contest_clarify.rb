class ContestClarify < ActiveRecord::Base
  self.table_name = "contest_clarify"
  self.primary_key = "ccid"

  belongs_to :questioner, class_name: "User", primary_key: "username", foreign_key: "username", inverse_of: :clarifies
  belongs_to :contest, primary_key: "cid", foreign_key: "cid", inverse_of: :clarifies
end
