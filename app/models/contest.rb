class Contest < ActiveRecord::Base
  self.table_name = "contest"
  self.primary_key = "cid"
  self.inheritance_column = :_type_disabled

  has_many :runs, class_name: "Status", primary_key: "cid",
      foreign_key: "contest_belong", inverse_of: :contest
  has_many :replay_runs, class_name: "ReplayStatus", primary_key: "cid",
      foreign_key: "contest_belong", inverse_of: :contest
  has_many :clarifies, class_name: "ContestClarify", primary_key: "cid",
      foreign_key: "cid", inverse_of: :contest
  has_many :problem_infos, class_name: "ContestProblem", primary_key: "cid",
      foreign_key: "cid", inverse_of: :contest
  has_many :challenges, primary_key: "cid", foreign_key: "cid",
      inverse_of: :contest

  scope :standard, -> { where(isvirtual: 0)}
  scope :virtual, -> { where(isvirtual: 1)}
  scope :scheduled, -> { where('start_time > NOW()')}
  scope :running, -> { where('
      start_time < NOW() AND (
        end_time > NOW() OR
        (
          has_cha = 1 AND
          challenge_end_time > NOW()
        )
      )
  ') }

  # Real contest end time for each type of contest.
  def final_time
    return challenge_end_time if has_cha
    return end_time
  end

  # Whether is in challenging phase, always false for non challenge contest.
  def challenging?
    return false unless has_cha
    return Time.now > challenge_start_time && Time.now < challenge_end_time
  end

  # Whether is in coding phase, or running for non challenge contest.
  def coding?
    return Time.now > start_time && Time.now < end_time
  end

  # Whether is in intermission phase, always false for non challenge contest.
  def intermission?
    return false unless has_cha
    return Time.now > end_time && Time.now < challenge_start_time
  end

  # Whether contest has started.
  def started?
    return Time.now > start_time
  end

  # Whether contest is running.
  def running?
    return Time.now > start_time && Time.now < final_time
  end

  # Whether contest has finished.
  def ended?
    return Time.now > final_time
  end

  # Status display text for datatables.
  # TODO(51isoft): I18n.
  def status_text
    return "Running" if running?
    return "Scheduled" if !started?
    return "Passed" if ended?
  end

  # Access text for datatables.
  # TODO(51isoft): I18n.
  def access_text
    case isprivate
    when 1
      "Private"
    when 2
      "Password"
    else
      "Public"
    end
  end

  # Formats start time for datatables.
  def start_time_display
    start_time.strftime OJ_CONFIG["misc"]["datetime_format"]
  end

  # Formats end time for datatables.
  def final_time_display
    final_time.strftime OJ_CONFIG["misc"]["datetime_format"]
  end

  # Whether username is in this contest.
  def has_user username
    case isprivate
    when 1
      !ContestUser.where(username: username, cid: cid).empty?
    when 2
      # TODO: Password type
      false
    else
      true
    end
  end

end
