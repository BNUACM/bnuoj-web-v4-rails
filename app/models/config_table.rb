class ConfigTable < ActiveRecord::Base
  self.table_name = "config"
  self.primary_key = "id"
end
