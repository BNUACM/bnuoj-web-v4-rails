class ProblemCategory < ActiveRecord::Base
	self.table_name = "problem_category"
	self.primary_key = "pcid"

	belongs_to :category, primary_key: "id", foreign_key: "catid",
      inverse_of: :problem_categories
end
