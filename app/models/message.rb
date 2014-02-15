class Message < ActiveRecord::Base
    self.table_name = "mail"
    self.primary_key = "mailid"

    belongs_to :sender, class_name: "User", primary_key: "sender", foreign_key: "username", inverse_of: :out_messages
    belongs_to :receiver, class_name: "User", primary_key: "reciever", foreign_key: "username", inverse_of: :in_messages
end
