class Challenge < ActiveRecord::Base
  self.table_name = "challenge"
  self.primary_key = "cha_id"

  belongs_to :contest, primary_key: "cid", foreign_key: "cid"
  belongs_to :challenger, class_name: "User", primary_key: "username", foreign_key: "username"
  belongs_to :run, class_name: "Status", primary_key: "runid", foreign_key: "runid"
end
