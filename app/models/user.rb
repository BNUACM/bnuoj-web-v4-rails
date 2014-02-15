class User < ActiveRecord::Base
  self.table_name = "user"
  self.primary_key = "uid"

  has_many :runs, class_name: "Status", primary_key: "username", foreign_key: "username", inverse_of: :user
  has_many :in_messages, class_name: "Message", primary_key: "username", foreign_key: "reciever", inverse_of: :receiver
  has_many :out_messages, class_name: "Message", primary_key: "username", foreign_key: "sender", inverse_of: :sender
  has_many :clarifies, class_name: "ContestClarify", primary_key: "username", foreign_key: "username", inverse_of: :questioner
  has_many :tags, primary_key: "username", foreign_key: "username", inverse_of: :user

  def to_json(options={})
    if options[:except].nil?
      options[:except] = []
    end
    options[:except] |= [:password, :photo, :total_value, :lock_status, :isroot]
    super(options)
  end

  def is_admin?
    isroot == 1
  end

  def unread_message_count
    in_messages.where(status: 0).count
  end

  def is_problem_accepted? pid
    runs.where(result: "Accepted", pid: pid).count > 0
  end

  def is_problem_submitted? pid
    runs.where(pid: pid).count > 0
  end

end
