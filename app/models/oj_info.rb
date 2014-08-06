class OjInfo < ActiveRecord::Base
  self.table_name = "ojinfo"
  self.primary_key = "id"

  def lastcheck_display
    lastcheck.strftime OJ_CONFIG["misc"]["datetime_format"]
  end
end
