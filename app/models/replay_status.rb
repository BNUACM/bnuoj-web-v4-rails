class ReplayStatus < ActiveRecord::Base
  self.table_name = "replay_status"
  self.primary_key = "runid"

  belongs_to :contest, primary_key: "contest_belong", foreign_key: "cid",
      inverse_of: :replay_runs
end
