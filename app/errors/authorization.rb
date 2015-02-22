module Authorization
  class NotAuthorized < StandardError; end
  class NotLoggedIn < StandardError; end
end
