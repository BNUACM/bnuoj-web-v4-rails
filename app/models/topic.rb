class Topic < ActiveRecord::Base
  self.table_name = "time_bbs"
  self.primary_key = "rid"

  belongs_to :problem, primary_key: 'pid', foreign_key: 'pid'
  has_many :discusses, primary_key: 'rid', foreign_key: 'rid', inverse_of: :topic
end
