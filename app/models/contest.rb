class Contest < ActiveRecord::Base
  self.table_name = "contest"
  self.primary_key = "cid"
  self.inheritance_column = :_type_disabled

  has_many :runs, class_name: "Status", primary_key: "cid", foreign_key: "contest_belong", inverse_of: :contest
  has_many :replay_runs, class_name: "ReplayStatus", primary_key: "cid", foreign_key: "contest_belong", inverse_of: :contest
  has_many :clarifies, class_name: "ContestClarify", primary_key: "cid", foreign_key: "cid", inverse_of: :contest
  has_many :problem_infos, class_name: "ContestProblem", primary_key: "cid", foreign_key: "cid", inverse_of: :contest
  has_many :challenges, primary_key: "cid", foreign_key: "cid", inverse_of: :contest

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

  def final_time
    return challenge_end_time if has_cha
    return end_time
  end

  def challenging?
    return false unless has_cha
    return Time.now > challenge_start_time && Time.now < challenge_end_time
  end

  def coding?
    return Time.now > start_time && Time.now < end_time
  end

  def intermission?
    return false unless has_cha
    return Time.now > end_time && Time.now < challenge_start_time
  end

  def started?
    return Time.now > start_time
  end

  def running?
    return Time.now > start_time && Time.now < final_time
  end

  def ended?
    return Time.now > final_time
  end

  def status_text
    return "Running" if running?
    return "Scheduled" if !started?
    return "Passed" if ended?
  end

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

  def start_time_display
    start_time.to_s :db
  end

  def final_time_display
    final_time.to_s :db
  end

end
