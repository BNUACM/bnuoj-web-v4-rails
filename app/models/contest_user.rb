class ContestUser < ActiveRecord::Base
    self.table_name = "contest_user"
    self.primary_key = "cuid"
end
