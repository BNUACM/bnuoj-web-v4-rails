class Status < ActiveRecord::Base
  self.table_name = "status"
  self.primary_key = "runid"

  belongs_to :contest, primary_key: "contest_belong", foreign_key: "cid", inverse_of: :runs
  belongs_to :user, primary_key: "username", foreign_key: "username", inverse_of: :runs
  has_one :language_name, primary_key: "language", foreign_key: "id"

  scope :accepted, ->{ where(result: "Accepted") }
  scope :public_contests, ->{ joins('LEFT JOIN contest ON status.contest_belong = contest.cid').where('contest_belong = 0 OR end_time < NOW()') }

  # Override to specify the columns to show.
  def to_json(options = {})
    options[:methods] = [] if options[:methods].nil?
    options[:except] = [] if options[:except].nil?
    options[:include] = [] if options[:include].nil?

    options[:except] |= [:jnum, :time_submit]
    options[:include] |= [:language_name]
    options[:methods] |= [:time_submit_display]
    super(options)
  end

  # Format time_submit.
  def time_submit_display
    begin
      time_submit.strftime OJ_CONFIG["misc"]["datetime_format"]
    rescue
      time_submit
    end
  end
end
