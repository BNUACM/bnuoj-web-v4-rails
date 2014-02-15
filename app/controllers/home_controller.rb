class HomeController < ApplicationController
  def index
  end

  def server_time
    render text: Time.now.to_s
  end
end
