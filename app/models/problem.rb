class Problem < ActiveRecord::Base
  self.table_name = "problem"
  self.primary_key = "pid"

  has_one :oj_info, primary_key: "vname", foreign_key: "name"
  has_many :discusses, primary_key: 'pid', foreign_key: 'pid', inverse_of: :problem
  scope :public, -> { where(hide: 0) }
  scope :user_unsolved, ->(username) { 
    where(' pid NOT IN ( SELECT DISTINCT(pid) FROM status WHERE result = "Accepted" AND username = ? ) ', username)
  }
  
end
