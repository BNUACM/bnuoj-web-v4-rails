class Status < ActiveRecord::Base
  self.table_name = "status"
  self.primary_key = "runid"

  belongs_to :contest, primary_key: "contest_belong", foreign_key: "cid", inverse_of: :runs
  belongs_to :user, primary_key: "username", foreign_key: "username", inverse_of: :runs
  has_one :language_name, primary_key: "language", foreign_key: "id"

  scope :accepted, ->{ where(result: "Accepted") }
  scope :public, ->{ joins('LEFT JOIN contest ON status.contest_belong = contest.cid').where('contest_belong = 0 OR end_time<NOW()') }

  def time_submit_display
    time_submit.to_s :db
  end
end
