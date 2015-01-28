class Category < ActiveRecord::Base
  self.table_name = "category"
  self.primary_key = "id"

  has_many :problem_categories, primary_key: "catid", foreign_key: "id", inverse_of: :category
end
