class User < ActiveRecord::Base
  include Privileged

  self.table_name = "user"
  self.primary_key = "uid"

  has_many :runs, class_name: "Status", primary_key: "username", foreign_key: "username", inverse_of: :user
  has_many :in_messages, class_name: "Message", primary_key: "username", foreign_key: "reciever", inverse_of: :receiver
  has_many :out_messages, class_name: "Message", primary_key: "username", foreign_key: "sender", inverse_of: :sender
  has_many :clarifies, class_name: "ContestClarify", primary_key: "username", foreign_key: "username", inverse_of: :questioner
  has_many :tags, primary_key: "username", foreign_key: "username", inverse_of: :user
  has_and_belongs_to_many :user_groups, inverse_of: :users


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

  # Get privileges, combined with user-based and group-based
  def get_merged_priv
    if @my_priv.nil?
      @my_priv = parse_priv
      user_groups.each do |group|
        @my_priv = @my_priv.merge group.parse_priv
      end
    end
    return @my_priv
  end

end

