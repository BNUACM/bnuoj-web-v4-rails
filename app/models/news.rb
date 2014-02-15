class News < ActiveRecord::Base
  self.table_name = "news"
  self.primary_key = "newsid"

  def time_added_display
    time_added.to_s :db
  end
end
