class News < ActiveRecord::Base
  self.table_name = "news"
  self.primary_key = "newsid"

  def time_added_display
    time_added.strftime OJ_CONFIG["misc"]["datetime_format"]
  end
end
