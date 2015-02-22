class ContestProblem < ActiveRecord::Base
  self.table_name = "contest_problem"
  self.primary_key = "cpid"
  self.inheritance_column = :_type_disabled

  belongs_to :contest, primary_key: "cid", foreign_key: "cid",
      inverse_of: :problem_infos
  has_one :problem, primary_key: "pid", foreign_key: "pid"
end
