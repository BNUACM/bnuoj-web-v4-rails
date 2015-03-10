class User < ActiveRecord::Base
  self.table_name = "user"
  self.primary_key = "uid"

  has_many :runs, class_name: "Status", primary_key: "username",
      foreign_key: "username", inverse_of: :user
  has_many :in_messages, class_name: "Message", primary_key: "username",
      foreign_key: "reciever", inverse_of: :receiver
  has_many :out_messages, class_name: "Message", primary_key: "username",
      foreign_key: "sender", inverse_of: :sender
  has_many :clarifies, class_name: "ContestClarify", primary_key: "username",
      foreign_key: "username", inverse_of: :questioner
  has_many :tags, primary_key: "username", foreign_key: "username",
      inverse_of: :user
  has_many :privileges, inverse_of: :user
  has_many :sessions, primary_key: "username", foreign_key: "username",
      inverse_of: :user

  # Override to specify the columns to show.
  def to_json(options = {})
    if options[:except].nil?
      options[:except] = []
    end
    options[:except] |= [:password, :photo, :total_value, :lock_status, :isroot]
    super(options)
  end

  # Admin check
  def is_admin?
    isroot == 1
  end

  def is_owner_of? contest
    contest.owner == name
  end

  def unread_message_count
    in_messages.where(status: 0).count
  end

  # Whether user accepted pid
  def is_problem_accepted? pid
    runs.where(result: "Accepted", pid: pid).count > 0
  end

  # Whether user submitted pid
  def is_problem_submitted? pid
    runs.where(pid: pid).count > 0
  end

  # Whether user has certain privilege
  def can? (privilege, restriction = {"any" => "any"})
    is_admin? ||
        privileges.where(
            privilege: privilege,
            restrict_to_key: restriction.keys[0],
            restrict_to_value: restriction.values[0]).count > 0
  end

end
